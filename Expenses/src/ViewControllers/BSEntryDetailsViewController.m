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
#import "BSConstants.h"

//static const NSInteger EXPENSES_SEGMENTED_INDEX = 0;
//static const NSInteger BENEFITS_SEGMENTED_INDEX = 1;

@interface BSEntryDetailsViewController ()
@property (assign, nonatomic) BOOL isShowingDatePicker;
@property (assign, nonatomic) BOOL buttonSelected;
@property (strong, nonatomic) NSDictionary *indexpathToPropertyMap;
@property (strong, nonatomic) NSDictionary *cellTypeToIndepathMap;
@end

@implementation BSEntryDetailsViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indexpathToPropertyMap = @{ [NSIndexPath indexPathForRow:0 inSection:0] : @"value",
                                      [NSIndexPath indexPathForRow:1 inSection:0] : @"desc",
                                      [NSIndexPath indexPathForRow:2 inSection:0] : @"date",
                                      [NSIndexPath indexPathForRow:3 inSection:0] : [NSNull null],
                                      [NSIndexPath indexPathForRow:0 inSection:1] : [NSNull null] };
    
    self.cellTypeToIndepathMap = @{ @"amount" : [NSIndexPath indexPathForRow:0 inSection:0],
                                    @"description" : [NSIndexPath indexPathForRow:1 inSection:0],
                                    @"date" : [NSIndexPath indexPathForRow:2 inSection:0],
                                    @"type" : [NSIndexPath indexPathForRow:3 inSection:0],
                                    @"delete" : [NSIndexPath indexPathForRow:0 inSection:1]};

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

- (void) tableView:(UITableView *)tableView willDisplayCell:(BSEntryDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[BSEntryDetailCell class]])
    {
        if (!cell.entryModel)
        {
            cell.modelProperty = self.indexpathToPropertyMap[indexPath]; // needs to be called before than the entryModel
            cell.entryModel = self.entryModel;
        }
        
        if ([indexPath isEqual:self.cellTypeToIndepathMap[@"amount"]])
        {
            if (!self.isEditingEntry)
            {
                [cell becomeFirstResponder];
            }
        }
    }
}

- (BOOL) saveModel
{
    BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    
    NSDate *creationDate = [NSDate date];
    if (self.entryModel.date) {
        creationDate = self.entryModel.date;
    }
    
    // Save
    BSEntrySegmentedOptionCell *typeCell = (BSEntrySegmentedOptionCell *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"type"]];
    BOOL isAmountNegative = typeCell.selectedIndex == EXPENSES_SEGMENTED_INDEX;
    return [coreDataController saveEntry:self.entryModel withNegativeAmount:isAmountNegative];

}

- (IBAction) addEntryPressed:(id)sender
{
    if ([self saveModel])
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark - UITextFieldDelegate

- (void) textFieldShouldreturn
{

    [self saveModel];
    if (!self.isEditingEntry)
    {
        BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
        self.entryModel = [coreDataController newEntry];
        
        BSEntryDetailCell *amountCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"amount"]];
        BSEntryDetailCell *descCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"description"]];
        BSEntryDetailCell *dateCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"date"]];
        BSEntryDetailCell *typeCell = (BSEntryDetailCell *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"type"]];
        [amountCell reset];
        [descCell reset];
        [dateCell reset];
        [typeCell reset];
    }

}

- (void)keyboardWillShow:(id)notification
{
    //[self hideDatePickerAnimated:YES];
    if (self.isShowingDatePicker)
    {
//        [self hideDatePickerAnimated:YES];
    }
}

- (void)keyboardDidHide:(id)notification
{
    //[self showDatePickerAnimated:YES];
}




#pragma mark - Updating the model

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


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.cellTypeToIndepathMap[@"date"]])
    {
        
        if (self.buttonSelected)
        {
            
            return 250.0f;
        } else
        {
            return 41.0f;
        }
    }
    else
    {
        return 41;
    }
}

#pragma mark - EntryDetailCellDelegateProtocol

- (void) cell:(UITableViewCell *)cell changedValue:(id)newValue
{
    if ([cell isKindOfClass:[BSEntrySegmentedOptionCell class]])
    {
        BSEntryTextDetail *amountCell = (BSEntryTextDetail *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"amount"]];
        
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
        BSEntryTextDetail *amountCell = (BSEntryTextDetail *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"amount"]];
        BSEntryTextDetail *descriptionCell = (BSEntryTextDetail *)[self.tableView cellForRowAtIndexPath:self.cellTypeToIndepathMap[@"description"]];

        if (self.buttonSelected)
        {
            [amountCell resignFirstResponder];
            [descriptionCell resignFirstResponder];
        }

        [self.tableView beginUpdates];
        [self.tableView endUpdates];
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
            //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

@end
