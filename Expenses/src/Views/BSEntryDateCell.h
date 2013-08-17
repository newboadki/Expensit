//
//  BSEntryDateCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailCell.h"

@interface BSEntryDateCell : BSEntryDetailCell

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction) entryDatePickerValueChanged:(UIButton *)dateButton;
- (IBAction) dateButtonPressed:(id)sender;

@end
