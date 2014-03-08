//
//  BSStaticTableAddEntryFormCellActionDataSource.m
//  Expenses
//
//  Created by Borja Arias Drake on 05/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableAddEntryFormCellActionDataSource.h"
#import "DateTimeHelper.h"
#import "BSEntryTextDetail.h"
#import "BSEntryDateCell.h"
#import "BSEntrySegmentedOptionCell.h"
#import "BSEntryDetailSingleButtonCell.h"
#import "BSConstants.h"
#import "BSCoreDataController.h"
#import "BSStaticTableViewSectionInfo.h"
#import "BSStaticTableViewCellInfo.h"
#import <UIKit/UIKit.h>
#import "Tag.h"
#import "BSStaticTableViewCellAction.h"
#import "BSTagToSegmentedControlCellConvertor.h"
#import "BSEntryTypeToSegmentedControlCellConvertor.h"
#import "BSAmountToTextControlCellConvertor.h"
#import "BSStaticTableViewCellChangeOfValueEvent.h"
#import "BSStaticTableViewCellFoldingEvent.h"
#import "BSStaticTableViewToggleExpandableCellsAction.h"
#import "BSStaticTableViewAbstractAction.h"
#import "BSCoreDataController.h"
#import "BSAppDelegate.h"
#import "CoreDataStackHelper.h"
#import "BSStaticTableViewDismissYourselfAction.h"

@implementation BSStaticTableAddEntryFormCellActionDataSource


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


- (id<BSStaticTableCellValueConvertorProtocol>)valueConvertorForCellAtIndexPath:(NSIndexPath *)indexPath
{
    BSStaticTableViewCellInfo *cellInfo = [self cellInfoForIndexPath:indexPath];
    return cellInfo.valueConvertor;
}


- (NSArray *)actionsForEvent:(BSStaticTableViewCellAbstractEvent *)event inCellAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:0]]) // TYPE
    {
        return [self actionsForEventInType:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]]) { // DATE
        
        return [self actionsForEventInDate:event indexPath:indexPath];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:4 inSection:0]]) { // CATEGORY
        return nil;
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) { // DELETE
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
        // 1 if the change was expanded/collapsed
        // -> Action is to animate the tableView
        return @[[[BSStaticTableViewToggleExpandableCellsAction alloc] initWithIndexPaths:@[indexPath]]];
    }
    else
    {
        return nil;
    }
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

- (NSArray *)sharedSectionsInfo
{
    BSTagToSegmentedControlCellConvertor *tagToSegmentedControlConvertor = [[BSTagToSegmentedControlCellConvertor alloc] init];
    tagToSegmentedControlConvertor.coreDataController = self.coreDataController;
    BSEntryTypeToSegmentedControlCellConvertor *typeToSegmentedControlVoncertor = [[BSEntryTypeToSegmentedControlCellConvertor alloc] init];
    NSArray *tags = [[self.coreDataController allTags] valueForKeyPath:@"name"];
    UIColor *grayColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme grayColor];
    NSDictionary *tagsExtraParams = @{@"options": tags, @"width": @230, @"colors" : @[grayColor, grayColor, grayColor, grayColor, grayColor]};
    NSDictionary *typeExtraParams = @{@"options": @[@"Expense", @"Benefit"], @"colors" : @[[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor], [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor]]};
    
    
    BSStaticTableViewCellInfo *amountCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryTextDetail class] propertyName:@"value" displayPropertyName:@"Amount" shouldBecomeFirstResponderWhenNotEditing:!self.isEditing keyboardType:UIKeyboardTypeDecimalPad valueConvertor:[[BSAmountToTextControlCellConvertor alloc] init] extraParams:nil];
    BSStaticTableViewCellInfo *descriptionCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryTextDetail class] propertyName:@"desc" displayPropertyName:@"Description" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:UIKeyboardTypeAlphabet valueConvertor:nil extraParams:nil];
    BSStaticTableViewCellInfo *dateCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDateCell class] propertyName:@"date"displayPropertyName:@"When" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:nil extraParams:nil];
    BSStaticTableViewCellInfo *categoryCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntrySegmentedOptionCell class] propertyName:@"tag" displayPropertyName:@"Group" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:tagToSegmentedControlConvertor extraParams:tagsExtraParams]; // nil because we need to search the tag entity and that's not for the cell to do
    BSStaticTableViewCellInfo *typeCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntrySegmentedOptionCell class] propertyName:@"isAmountNegative" displayPropertyName:@"Type" shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:typeToSegmentedControlVoncertor extraParams:typeExtraParams]; // nil because the type it's determined by the sign of the value not by a property in itself
    
    return @[[[BSStaticTableViewSectionInfo alloc] initWithSection:0 cellsInfo:@[amountCellInfo, descriptionCellInfo, dateCellInfo, typeCellInfo, categoryCellInfo]]];
    
}


- (NSArray *)editingOnlySectionsInfo
{
    BSStaticTableViewCellInfo *deleteCellInfo = [[BSStaticTableViewCellInfo alloc] initWithCellClass:[BSEntryDetailSingleButtonCell class] propertyName:nil displayPropertyName:nil shouldBecomeFirstResponderWhenNotEditing:NO keyboardType:0 valueConvertor:nil extraParams:nil];
    
    return @[[[BSStaticTableViewSectionInfo alloc] initWithSection:1 cellsInfo:@[deleteCellInfo]]];
    
}




@end
