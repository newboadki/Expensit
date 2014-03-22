//
//  BSStaticTableAddEntryFormCellActionDataSource.m
//  Expenses
//
//  Created by Borja Arias Drake on 05/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableAddEntryFormCellActionDataSource.h"
#import "DateTimeHelper.h"

#import "BSTableViewCellDescriptors.h"
#import "BSTableViewEvents.h"
#import "BSTableViewCellActions.h"
#import "BSCells.h"

#import "BSConstants.h"
#import "BSCoreDataController.h"
#import "CoreDataStackHelper.h"
#import "Tag.h"

#import <UIKit/UIKit.h>

#import "BSTagToSegmentedControlCellConvertor.h"
#import "BSEntryTypeToSegmentedControlCellConvertor.h"
#import "BSAmountToTextControlCellConvertor.h"
#import "BSDateToDatePickerCellConvertor.h"

#import "BSAppDelegate.h"

@interface BSStaticTableAddEntryFormCellActionDataSource ()
@property (nonatomic, assign) BOOL showingDatePicker;
@property (nonatomic, assign) BOOL showingCategoryPicker;
@end

@implementation BSStaticTableAddEntryFormCellActionDataSource
{
    NSMutableArray *_sharedSectionInfo;
}


#pragma mark - Initialisers

- (instancetype)initWithCoreDataController:(BSCoreDataController *)coreDataController isEditing:(BOOL)isEditing
{
    self = [super init];
    if (self)
    {
        _coreDataController = coreDataController;
        _isEditing = isEditing;
    }
    return self;
}



#pragma mark - BSStaticFormTableViewCellActionDataSourceProtocol

- (NSArray *)sectionsInfo
{
    if (self.isEditing)
    {
        return [[self sharedSectionsInfo] arrayByAddingObjectsFromArray:[self editingOnlySectionsInfo]];
    }
    else
    {
        return [self sharedSectionsInfo];
    }
}


- (BSStaticTableViewCellInfo *)cellInfoForIndexPath:(NSIndexPath *)indepath
{
    BSStaticTableViewSectionInfo *sectionInfo = self.sectionsInfo[indepath.section];
    return sectionInfo.cellClassesInfo[indepath.row];
}


- (id<BSStaticFormTableCellValueConvertorProtocol>)valueConvertorForCellAtIndexPath:(NSIndexPath *)indexPath
{
    BSStaticTableViewCellInfo *cellInfo = [self cellInfoForIndexPath:indexPath];
    return cellInfo.valueConvertor;
}


- (NSArray *)actionsForEvent:(BSStaticTableViewCellAbstractEvent *)event inCellAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([indexPath isEqual:[self indexPathForDateCell]]) { // DATE
        return [self actionsForEventInDate:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[self indexPathForDatePickerCell]]) { // DATE PICKER
        return [self actionsForEventInDatePicker:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[self indexPathForTypeCell]]) // TYPE
    {
        return [self actionsForEventInType:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[self indexPathForCategoryCell]]) { // CATEGORY
        return [self actionsForEventInCategory:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[self indexPathForCategoryPickerCell]]) { // CATEGORY PICKER
        return [self actionsForEventInCategoryPicker:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[self indexPathForDeleteCell]]) { // DELETE
        return [self actionsForEventInDelete:event indexPath:indexPath];
    }
    else
    {
        return nil;
    }
}



#pragma mark - Action helpers

- (NSArray *)actionsForEventInType:(BSStaticTableViewCellAbstractEvent *)event indexPath:(NSIndexPath *)indexPath
{
    if ([event isKindOfClass:[BSStaticTableViewCellChangeOfValueEvent class]])
    {
        id newValue = [(BSStaticTableViewCellChangeOfValueEvent *)event value];
        BOOL isExpense = [(NSNumber *)newValue boolValue];
        
        if (isExpense)
        {
            return @[[[BSStaticTableViewCellAction alloc] initWithIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] action:@selector(displayMinusSign) withObject:nil]];
        }
        else
        {
            return @[[[BSStaticTableViewCellAction alloc] initWithIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] action:@selector(displayPlusSign) withObject:nil]];
        }
    }
    else
    {
        return nil;
    }
}

- (NSArray *)actionsForEventInDate:(BSStaticTableViewCellAbstractEvent *)event indexPath:(NSIndexPath *)indexPath
{
    if ([event isKindOfClass:[BSStaticTableViewCellFoldingEvent class]])
    {
        if (!self.showingDatePicker)
        {
            self.showingDatePicker = YES;
            // Update the data model
            BSDateToDatePickerCellConvertor *dateConvertor = [[BSDateToDatePickerCellConvertor alloc] init];
            BSStaticTableViewCellInfo *datePickerCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDetailDatePickerCell class] propertyName:@"date" displayPropertyName:nil shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:dateConvertor extraParams:nil];
            BSStaticTableViewSectionInfo *si = [self sharedSectionsInfo][0];
            [si.cellClassesInfo insertObject:datePickerCellInfo atIndex:3];
            
            // Create the actions
            BSStaticTableViewSelectRowAction *selectRowAction = [[BSStaticTableViewSelectRowAction alloc] initWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]];
            
            BSStaticTableViewInsertRowAction *insertRowAction = [[BSStaticTableViewInsertRowAction alloc] initWithIndexPath:[NSIndexPath indexPathForRow:3 inSection:indexPath.section]];
            
            return @[selectRowAction, insertRowAction];

        }
        else
        {
            self.showingDatePicker = NO;
            // Update the data model
            BSStaticTableViewSectionInfo *si = [self sharedSectionsInfo][0];
            [si.cellClassesInfo removeObjectAtIndex:3];
            
            // Create the actions
            BSStaticTableViewDeselectRowAction *deselectRowAction = [[BSStaticTableViewDeselectRowAction alloc] initWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]];
            
            BSStaticTableViewRemoveRowAction *removeRowAction = [[BSStaticTableViewRemoveRowAction alloc] initWithIndexPath:[NSIndexPath indexPathForRow:3 inSection:indexPath.section]];
            
            return @[deselectRowAction, removeRowAction];
        }
    }
    else
    {
        return nil;
    }
}


- (NSArray *)actionsForEventInDatePicker:(BSStaticTableViewCellAbstractEvent *)event indexPath:(NSIndexPath *)indexPath
{
    return @[[[BSStaticTableViewReloadCellFromModel alloc] initWithIndexPath:[self indexPathForDateCell]]];
}


- (NSArray *)actionsForEventInCategory:(BSStaticTableViewCellAbstractEvent *)event indexPath:(NSIndexPath *)indexPath
{
    if ([event isKindOfClass:[BSStaticTableViewCellFoldingEvent class]])
    {
        
        if (!self.showingCategoryPicker)
        {
            self.showingCategoryPicker = YES;
            // Update the data model
            BSTagToSegmentedControlCellConvertor *tagToSegmentedControlConvertor = [[BSTagToSegmentedControlCellConvertor alloc] init];
            tagToSegmentedControlConvertor.coreDataController = self.coreDataController;

            NSArray *tags = [[self.coreDataController allTags] valueForKeyPath:@"name"];
            UIColor *grayColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme grayColor];
            NSDictionary *tagsExtraParams = @{@"options": tags, @"width": @230, @"colors" : @[grayColor, grayColor, grayColor, grayColor, grayColor]};
            BSStaticTableViewCellInfo *categoryPickerCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDetailValuePickerCell class] propertyName:@"tag" displayPropertyName:@"Group" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:tagToSegmentedControlConvertor extraParams:tagsExtraParams];
            BSStaticTableViewSectionInfo *si = [self sharedSectionsInfo][0];
            [si.cellClassesInfo insertObject:categoryPickerCellInfo atIndex:[self indexPathForCategoryPickerCell].row];
            
            // Create the actions
            BSStaticTableViewSelectRowAction *selectRowAction = [[BSStaticTableViewSelectRowAction alloc] initWithIndexPath:[self indexPathForCategoryCell]];
            
            BSStaticTableViewInsertRowAction *insertRowAction = [[BSStaticTableViewInsertRowAction alloc] initWithIndexPath:[NSIndexPath indexPathForRow:[self indexPathForCategoryPickerCell].row inSection:indexPath.section]];
            
            return @[selectRowAction, insertRowAction];
            
        }
        else
        {
            
            // Update the data model
            BSStaticTableViewSectionInfo *si = [self sharedSectionsInfo][0];
            [si.cellClassesInfo removeObjectAtIndex:[self indexPathForCategoryPickerCell].row];
            
            // Create the actions
            BSStaticTableViewDeselectRowAction *deselectRowAction = [[BSStaticTableViewDeselectRowAction alloc] initWithIndexPath:[self indexPathForCategoryCell]];
            
            BSStaticTableViewRemoveRowAction *removeRowAction = [[BSStaticTableViewRemoveRowAction alloc] initWithIndexPath:[self indexPathForCategoryPickerCell]];
            
            self.showingCategoryPicker = NO;
            return @[deselectRowAction, removeRowAction];
        }
    }
    else
    {
        return nil;
    }
}


- (NSArray *)actionsForEventInCategoryPicker:(BSStaticTableViewCellAbstractEvent *)event indexPath:(NSIndexPath *)indexPath
{
        
    return @[[[BSStaticTableViewReloadCellFromModel alloc] initWithIndexPath:[self indexPathForCategoryCell]]];
}


- (NSArray *)actionsForEventInDelete:(BSStaticTableViewCellAbstractEvent *)event indexPath:(NSIndexPath *)indexPath
{
    // The model to delete should come in the event!!
    
    // We could use a better event name
    
    BSStaticTableViewCellChangeOfValueEvent *changeEvent = (BSStaticTableViewCellChangeOfValueEvent *)event;
    id model = changeEvent.value;
    [self.coreDataController deleteModel:model];
    [self.coreDataController saveChanges];
    
    // The action to be taken by the view controller is to dismiss itself
    return @[[[BSStaticTableViewDismissYourselfAction alloc] init]];
}



#pragma mark - Helpers

- (NSMutableArray *)sharedSectionsInfo
{
    if (_sharedSectionInfo) {
        return _sharedSectionInfo;
    }
    
    BSTagToSegmentedControlCellConvertor *tagToSegmentedControlConvertor = [[BSTagToSegmentedControlCellConvertor alloc] init];
    tagToSegmentedControlConvertor.coreDataController = self.coreDataController;
    BSEntryTypeToSegmentedControlCellConvertor *typeToSegmentedControlVoncertor = [[BSEntryTypeToSegmentedControlCellConvertor alloc] init];
    BSDateToDatePickerCellConvertor *dateConvertor = [[BSDateToDatePickerCellConvertor alloc] init];
    NSDictionary *typeExtraParams = @{@"options": @[@"Expense", @"Benefit"], @"colors" : @[[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor], [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor]]};
    
    
    BSStaticTableViewCellInfo *amountCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryTextDetail class] propertyName:@"value" displayPropertyName:@"Amount" shouldBecomeFirstResponderWhenNotEditing:!self.isEditing keyboardType:UIKeyboardTypeDecimalPad valueConvertor:[[BSAmountToTextControlCellConvertor alloc] init] extraParams:nil];
    BSStaticTableViewCellInfo *descriptionCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryTextDetail class] propertyName:@"desc" displayPropertyName:@"Description" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:UIKeyboardTypeAlphabet valueConvertor:nil extraParams:nil];
    BSStaticTableViewCellInfo *dateButtonCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDetailDescriptionAndButtonCell class] propertyName:@"date"displayPropertyName:@"When" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:dateConvertor extraParams:nil];

    BSStaticTableViewCellInfo *categoryCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDetailDescriptionAndButtonCell class] propertyName:@"tag" displayPropertyName:@"Group" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:tagToSegmentedControlConvertor extraParams:nil]; // nil because we need to search the tag entity and that's not for the cell to do
    BSStaticTableViewCellInfo *typeCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntrySegmentedOptionCell class] propertyName:@"isAmountNegative" displayPropertyName:@"Type" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:typeToSegmentedControlVoncertor extraParams:typeExtraParams]; // nil because the type it's determined by the sign of the value not by a property in itself
    
    
    _sharedSectionInfo = [NSMutableArray arrayWithArray:@[[[BSStaticTableViewSectionInfo alloc] initWithSection:0 cellsInfo:[NSMutableArray arrayWithArray:@[amountCellInfo, descriptionCellInfo, dateButtonCellInfo, typeCellInfo, categoryCellInfo]]]]];
    
    return _sharedSectionInfo;
}


- (NSArray *)editingOnlySectionsInfo
{
    BSStaticTableViewCellInfo *deleteCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDetailSingleButtonCell class] propertyName:nil displayPropertyName:nil shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:nil extraParams:nil];
    
    return @[[[BSStaticTableViewSectionInfo alloc] initWithSection:1 cellsInfo:@[deleteCellInfo]]];
    
    
}


#pragma mark - IndexPath Helpers
- (NSIndexPath *)indexPathForAmountCell
{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath *)indexPathForDescriptionCell
{
    return [NSIndexPath indexPathForRow:1 inSection:0];
}

- (NSIndexPath *)indexPathForDateCell
{
    return [NSIndexPath indexPathForRow:2 inSection:0];
}

- (NSIndexPath *)indexPathForDatePickerCell
{
    if (self.showingDatePicker)
    {
        return [NSIndexPath indexPathForRow:3 inSection:0];
    }
    else
    {
        return nil;
    }
}

- (NSIndexPath *)indexPathForTypeCell
{
    if (self.showingDatePicker)
    {
        return [NSIndexPath indexPathForRow:4 inSection:0];
    }
    else
    {
        return [NSIndexPath indexPathForRow:3 inSection:0];
    }
}

- (NSIndexPath *)indexPathForCategoryCell
{
    if (self.showingDatePicker)
    {
        return [NSIndexPath indexPathForRow:5 inSection:0];
    }
    else
    {
        return [NSIndexPath indexPathForRow:4 inSection:0];
    }
    
}

- (NSIndexPath *)indexPathForCategoryPickerCell
{
    if (self.showingCategoryPicker)
    {
        if (self.showingDatePicker)
        {
            return [NSIndexPath indexPathForRow:6 inSection:0];
        }
        else
        {
            return [NSIndexPath indexPathForRow:5 inSection:0];
        }
    }
    else
    {
        if (self.showingDatePicker)
        {
            return [NSIndexPath indexPathForRow:6 inSection:0];
        }
        else
        {
            return [NSIndexPath indexPathForRow:5 inSection:0];
        }
    }
}

- (NSIndexPath *)indexPathForDeleteCell
{
    if (self.isEditing)
    {
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else
    {
        return nil;
    }
}



@end
