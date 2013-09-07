//
//  BSAddEntryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailsViewController.h"
#import "DateTimeHelper.h"
#import "BSEntryTextDetail.h"
#import "BSEntryDateCell.h"
#import "BSEntrySegmentedOptionCell.h"
#import "BSEntryDetailSingleButtonCell.h"
#import "BSEntryDetailDatePickerCell.h"
#import "BSConstants.h"

@interface BSEntryDetailsViewController ()
@property (assign, nonatomic) BOOL isShowingDatePicker;
@property (assign, nonatomic) BOOL buttonSelected;
@property (strong, nonatomic) NSMutableDictionary *listModelTypes;
@end

static  NSString *kAmountCellType = @"amount";
static  NSString *kDescriptionCellType = @"description";
static  NSString *kDateCellType = @"date";
static  NSString *kDatePickerCellType = @"datePicker";
static  NSString *kTypeCellType = @"type";
static  NSString *kDeleteCellType = @"delete";

@implementation BSEntryDetailsViewController

#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}



#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellType];
    // This is the structure of the cell. It can change as we might insert and delete cells
    self.listModelTypes = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSMutableArray arrayWithArray:@[kAmountCellType, kDescriptionCellType, kDateCellType, kTypeCellType]], @0,
                                                                               [NSMutableArray arrayWithArray:@[kDeleteCellType]], @1, nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if (self.isEditingEntry)
    {
        self.title = NSLocalizedString(@"Edit entry", @"");
    }
    else
    {
        self.title = NSLocalizedString(@"Add entry", @"");
    }
    
    // Create model
    if (!self.isEditingEntry)
    {
        BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
        self.entryModel = [coreDataController newEntry];
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView related

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isEditingEntry)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.listModelTypes[(@0)] count];
            break;
        case 1:
            return [self.listModelTypes[(@1)] count];
            break;
        default:
            return 0;
            break;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(BSEntryDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[BSEntryDetailCell class]])
    {
        if (!cell.entryModel)
        {
            cell.modelProperty = [self cellInfoForIndexPath:indexPath][@"property"]; // needs to be called before than the entryModel
            cell.entryModel = self.entryModel;
        }
        
        if ([indexPath isEqual:[self indexPathForCellType:kAmountCellType]])
        {
            cell.label.text = NSLocalizedString(@"Amount", @"");
            BSEntryTextDetail *textCell = (BSEntryTextDetail *)cell;
            textCell.keyboardType = UIKeyboardTypeDecimalPad;
            if (!self.isEditingEntry)
            {
                [cell becomeFirstResponder];
            }
        } else if ([indexPath isEqual:[self indexPathForCellType:kDescriptionCellType]]) {
            BSEntryTextDetail *textCell = (BSEntryTextDetail *)cell;
            textCell.keyboardType = UIKeyboardTypeEmailAddress;
            cell.label.text = NSLocalizedString(@"Description", @"");
        } if ([indexPath isEqual:[self indexPathForCellType:kDateCellType]]) {
            BSEntryDateCell *dateCell = (BSEntryDateCell *)dateCell;
            cell.label.text = NSLocalizedString(@"When", @"");
            
        } if ([indexPath isEqual:[self indexPathForCellType:kTypeCellType]]) {
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *reuseIdentifier = [[self cellInfoForIndexPath:indexPath][@"class"] description];
    BSEntryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        Class cellClass = NSClassFromString(reuseIdentifier);
        cell = [[cellClass alloc] init];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowingDatePicker) {
        if ([indexPath isEqual:[self indexPathForCellType:kDatePickerCellType]]) {
            return 250.0f;
        } else {
            return 44.0f;
        }
    } else {
        return 44.0;
    }
}


#pragma mark - Actions

- (IBAction) addEntryPressed:(id)sender
{
    if ([self saveModel])
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction) cancelButtonPressed:(id)sender
{
    if (!self.isEditingEntry)
    {
        BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry"
                                                                                           delegate:nil
                                                                                     coreDataHelper:self.coreDataStackHelper];
        [coreDataController.coreDataHelper.managedObjectContext deleteObject:self.entryModel];
        [self.coreDataStackHelper.managedObjectContext save:nil];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) saveModel
{
    BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    
    NSDate *creationDate = [NSDate date];
    if (self.entryModel.date) {
        creationDate = self.entryModel.date;
    }
    
    // Save
    BSEntrySegmentedOptionCell *typeCell = (BSEntrySegmentedOptionCell *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kTypeCellType]];
    BOOL isAmountNegative = typeCell.selectedIndex == EXPENSES_SEGMENTED_INDEX;
    return [coreDataController saveEntry:self.entryModel withNegativeAmount:isAmountNegative];
    
}



#pragma mark - UITextFieldDelegate

- (void) textFieldShouldreturn
{

    [self saveModel];
    if (!self.isEditingEntry)
    {
        BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
        self.entryModel = [coreDataController newEntry];
        
        
        BSEntryDetailCell *amountCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kAmountCellType]];
        BSEntryDetailCell *descCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kDescriptionCellType]];
        BSEntryDetailCell *dateCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kDateCellType]];
        BSEntryDetailCell *typeCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kTypeCellType]];
        
        amountCell.entryModel = self.entryModel;
        descCell.entryModel = self.entryModel;
        dateCell.entryModel = self.entryModel;
        typeCell.entryModel = self.entryModel;
        
        [amountCell becomeFirstResponder];
    }

}

- (void)keyboardWillShow:(id)notification
{

}

- (void)keyboardDidHide:(id)notification
{

}

#pragma mark - EntryDetailCellDelegateProtocol

- (void) cell:(UITableViewCell *)cell changedValue:(id)newValue
{
    if ([cell isKindOfClass:[BSEntrySegmentedOptionCell class]])
    {
        BSEntryTextDetail *amountCell = (BSEntryTextDetail *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kAmountCellType]];
        
        int value = [(NSNumber *)newValue intValue];
        switch (value) {
            case EXPENSES_SEGMENTED_INDEX:
                // Tell the amount cell to display a -
                [amountCell displayMinusSign];
                break;
            case BENEFITS_SEGMENTED_INDEX:
                // Tell the amount cell to display a +
                [amountCell displayPlusSign];
                break;
                
            default:
                break;
        }
    }
    else if ([cell isKindOfClass:[BSEntryDateCell class]])
    {
        self.buttonSelected = !self.buttonSelected;
        BSEntryTextDetail *amountCell = (BSEntryTextDetail *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kAmountCellType]];
        BSEntryTextDetail *descriptionCell = (BSEntryTextDetail *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kDescriptionCellType]];

        if (self.buttonSelected)
        {
            [amountCell resignFirstResponder];
            [descriptionCell resignFirstResponder];
        }

        NSMutableArray *typesInSection = self.listModelTypes[@0];
        if ([typesInSection count] == 4) {
            [self.tableView selectRowAtIndexPath:[self indexPathForCellType:kDateCellType] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [typesInSection insertObject:kDatePickerCellType atIndex:3];
            self.isShowingDatePicker = YES;
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.buttonSelected) {
                [self.tableView deselectRowAtIndexPath:[self indexPathForCellType:kDateCellType] animated:YES];

                BSEntryDetailDatePickerCell *pickerCell = (BSEntryDetailDatePickerCell *)[self.tableView cellForRowAtIndexPath:[self indexPathForCellType:kDatePickerCellType]];
                [pickerCell setup];
            }

            
        } else if ([typesInSection count] == 5){
            [typesInSection removeObjectAtIndex:3];
            self.isShowingDatePicker = NO;            
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
    }
    else if ([cell isKindOfClass:[BSEntryDetailSingleButtonCell class]])
    {
        if (self.isEditingEntry)
        {
            BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
            [coreDataController.coreDataHelper.managedObjectContext deleteObject:self.entryModel];
            [self.coreDataStackHelper.managedObjectContext save:nil];
            
            // If success
            UINavigationController *navController = self.navigationController;
            [navController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ([cell isKindOfClass:[BSEntryDetailDatePickerCell class]]) {
        BSEntryDateCell *dateCell = (BSEntryDateCell*)[self.tableView  cellForRowAtIndexPath:[self indexPathForCellType:kDateCellType]];
        [dateCell setDate:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:newValue]]
        ;
    }
}



#pragma mark - Dinamic table view helpers

- (NSIndexPath *)indexPathForCellType:(NSString *)cellType {
    // The index to return depends on editingMode and isShowingPicker
    if ([cellType isEqualToString:[kAmountCellType copy]]) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    } else if ([cellType isEqualToString:[kDescriptionCellType copy]]) {
        return [NSIndexPath indexPathForRow:1 inSection:0];
    } else if ([cellType isEqualToString:[kDateCellType copy]]) {
        return [NSIndexPath indexPathForRow:2 inSection:0];
    } else if ([cellType isEqualToString:[kDatePickerCellType copy]]) {
        return [NSIndexPath indexPathForRow:3 inSection:0];
    } else if ([cellType isEqualToString:[kTypeCellType copy]]) {
        if (self.isShowingDatePicker) {
            return [NSIndexPath indexPathForRow:4 inSection:0];
        } else {
            return [NSIndexPath indexPathForRow:3 inSection:0];
        }
    } else if ([cellType isEqualToString:[kDeleteCellType copy]]) {
        return [NSIndexPath indexPathForRow:0 inSection:1];
    } else {
        return nil;
    }
}

- (NSDictionary *)cellInfoForIndexPath:(NSIndexPath *)indexPath {
    // The index to return depends on editingMode and isShowingPicker
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        return @{@"property" : @"value", @"class" : [BSEntryTextDetail class]};
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]]) {
        return @{@"property" : @"desc", @"class" : [BSEntryTextDetail class]};
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]]) {
        return @{@"property" : @"date", @"class" : [BSEntryDateCell class]};
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:0]]) {
        if (self.isShowingDatePicker) {
            return @{@"property" : @"date", @"class" : [BSEntryDetailDatePickerCell class]};
        } else {
            return @{@"property" : [NSNull null], @"class" : [BSEntrySegmentedOptionCell class]};
        }
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:4 inSection:0]]) {
        return @{@"property" : [NSNull null], @"class" : [BSEntrySegmentedOptionCell class]};
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        return @{@"property" : [NSNull null], @"class" : [BSEntryDetailSingleButtonCell class]};
    } else {
        return nil;
    }
}

@end
