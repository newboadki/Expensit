//
//  BSAddEntryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAddEntryViewController.h"
#import "DateTimeHelper.h"


static const NSInteger EXPENSES_SEGMENTED_INDEX = 0;
static const NSInteger BENEFITS_SEGMENTED_INDEX = 1;

@interface BSAddEntryViewController ()
@property (strong, nonatomic) NSDate *selectedDate;
@end

@implementation BSAddEntryViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.amountTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    self.dateButton.titleLabel.text = [DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:[NSDate date]];
    [self.dateButton.titleLabel setNeedsDisplay];

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
    
    NSDate *creationDate = [NSDate date];
    if (self.selectedDate) {
        creationDate = self.selectedDate;
    }
    [coreDataController insertNewEntryWithDate:creationDate description:self.descriptionTextField.text value:amount];
    
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

- (void)keyboardDidShow:(id)notification
{
    [self hideDatePickerAnimated:YES];
}

- (void)keyboardDidHide:(id)notification
{
    [self showDatePickerAnimated:YES];
}


- (void) hideDatePickerAnimated:(BOOL)animated
{
    self.entryDatePicker.hidden = YES;
}

- (void) showDatePickerAnimated:(BOOL)animated
{
    CGRect atTheBottomFrame = self.entryDatePicker.frame;
    atTheBottomFrame.origin.y = CGRectGetMaxY(self.view.frame);
    self.entryDatePicker.hidden = NO;
    self.entryDatePicker.frame = atTheBottomFrame;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect visibleFrame = self.entryDatePicker.frame;
        visibleFrame.origin.y = self.view.frame.size.height - self.entryDatePicker.frame.size.height;
        self.entryDatePicker.frame = visibleFrame;
        
    } completion:nil];
}


- (IBAction) entryDatePickerValueChanged:(id)sender
{
    self.selectedDate = self.entryDatePicker.date;
    self.dateButton.titleLabel.text = [DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:self.selectedDate];
}

- (IBAction) dateButtonPressed:(id)sender
{
    [self.amountTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
}



@end
