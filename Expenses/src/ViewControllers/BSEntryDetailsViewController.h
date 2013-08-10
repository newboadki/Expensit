//
//  BSAddEntryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "Entry.h"


@interface BSEntryDetailsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *entryTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *entryTypeSymbolLabel;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *entryDatePicker;
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIView *bottomSectionView;

@property (assign, nonatomic) BOOL isEditingEntry;
@property (strong, nonatomic) Entry *entryModel;

- (IBAction) addEntryPressed:(id)sender;
- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl;
- (IBAction) entryDatePickerValueChanged:(id)sender;
- (IBAction) dateButtonPressed:(id)sender;

- (IBAction) amountTextFieldChanged:(UITextField *)textField;
- (IBAction) descriptionTextFieldChanged:(UITextField *)textField;

- (IBAction) deleteButtonPressed:(UIButton *)deleteButton;
@end
