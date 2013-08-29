//
//  BSEntryDateCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailCell.h"

@interface BSEntryDateCell : BSEntryDetailCell

@property (strong, nonatomic) UIDatePicker *datePicker;

- (void) entryDatePickerValueChanged:(UIButton *)dateButton;
- (IBAction) dateButtonPressed:(id)sender;

@end
