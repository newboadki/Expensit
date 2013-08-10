//
//  BSAddEntryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailsViewController.h"
#import "DateTimeHelper.h"


static const NSInteger EXPENSES_SEGMENTED_INDEX = 0;
static const NSInteger BENEFITS_SEGMENTED_INDEX = 1;

@interface BSEntryDetailsViewController ()
@property (assign, nonatomic) BOOL isShowingDatePicker;
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
	[self.amountTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    self.dateButton.titleLabel.text = [DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:[NSDate date]];
    [self.dateButton.titleLabel setNeedsDisplay];

    
    if (self.isEditingEntry)
    {
        self.title = NSLocalizedString(@"Edit entry", @"");
        self.amountTextField.text = [self.entryModel.value stringValue];
        self.descriptionTextField.text = self.entryModel.desc;
        self.deleteButton.hidden = NO;
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


- (IBAction) addEntryPressed:(id)sender
{
    BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    
    NSString *amount = self.amountTextField.text;
    if (self.entryTypeSegmentedControl.selectedSegmentIndex == EXPENSES_SEGMENTED_INDEX)
    {
        amount = [@"-" stringByAppendingString:amount];
    }
    
    self.entryModel.value = [NSDecimalNumber decimalNumberWithString:amount];
    NSDate *creationDate = [NSDate date];
    if (self.entryModel.date) {
        creationDate = self.entryModel.date;
    }
    
    // Save
    NSError *err = nil;
    [coreDataController.coreDataHelper.managedObjectContext save:&err];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl
{
    switch (typeSegmentedControl.selectedSegmentIndex) {
        case EXPENSES_SEGMENTED_INDEX:
            self.entryTypeSymbolLabel.text = @"-";
            typeSegmentedControl.tintColor = [UIColor colorWithRed:199.0/255.0 green:43.0/255.0 blue:49.0/255.0 alpha:1.0];
            break;
        case BENEFITS_SEGMENTED_INDEX:
            self.entryTypeSymbolLabel.text = @"+";
            typeSegmentedControl.tintColor = [UIColor colorWithRed:86.0/255.0 green:130.0/255.0 blue:61.0/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
}



- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    self.amountTextField.text = @"";
    self.descriptionTextField.text = @"";
    self.entryTypeSegmentedControl.selectedSegmentIndex = EXPENSES_SEGMENTED_INDEX; // Default
    [self entryTypeSegmenteControlChanged:self.entryTypeSegmentedControl];

    [self.amountTextField becomeFirstResponder];
    
    return NO;
}

- (void)keyboardWillShow:(id)notification
{
    //[self hideDatePickerAnimated:YES];
    if (self.isShowingDatePicker)
    {
        [self hideDatePickerAnimated:YES];
    }
}

- (void)keyboardDidHide:(id)notification
{
    //[self showDatePickerAnimated:YES];
}


- (void) hideDatePickerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect destinationFrame = self.bottomSectionView.frame;
        destinationFrame.origin.y -= CGRectGetHeight(self.entryDatePicker.frame);
        self.bottomSectionView.frame = destinationFrame;
    } completion:^(BOOL finished) {
        self.isShowingDatePicker = NO;
        [self.amountTextField becomeFirstResponder];
    }];

}

- (void) showDatePickerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect destinationFrame = self.bottomSectionView.frame;
        destinationFrame.origin.y += CGRectGetHeight(self.entryDatePicker.frame);
        self.bottomSectionView.frame = destinationFrame;
    } completion:^(BOOL finished) {
        self.isShowingDatePicker = YES;
    }];
}



- (IBAction) dateButtonPressed:(id)sender
{
    [self.amountTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    
    if (self.isShowingDatePicker)
    {
        [self hideDatePickerAnimated:YES];
    }
    else
    {
        [self showDatePickerAnimated:YES];
    }
}


#pragma mark - Updating the model

- (IBAction) entryDatePickerValueChanged:(id)sender
{
    self.entryModel.date = self.entryDatePicker.date;
    self.entryModel.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:self.entryModel.date]];
    self.entryModel.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:self.entryModel.date]];;
    self.entryModel.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:self.entryModel.date]];;
    self.entryModel.monthYear = [NSString stringWithFormat:@"%@/%@", [self.entryModel.month stringValue], [self.entryModel.year stringValue]];
    self.entryModel.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [self.entryModel.day stringValue], [self.entryModel.month stringValue], [self.entryModel.year stringValue]];

    self.dateButton.titleLabel.text = [DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:self.entryModel.date];
}


- (IBAction) amountTextFieldChanged:(UITextField *)textField
{
    self.entryModel.value = [NSDecimalNumber decimalNumberWithString:textField.text];
}


- (IBAction) descriptionTextFieldChanged:(UITextField *)textField
{
    self.entryModel.desc = textField.text;
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


- (IBAction) deleteButtonPressed:(UIButton *)deleteButton
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

@end
