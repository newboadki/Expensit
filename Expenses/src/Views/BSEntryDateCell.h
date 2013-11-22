//
//  BSEntryDateCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCell.h"

@interface BSEntryDateCell : BSStaticTableViewCell <BSTableViewExpandableCell>

@property (strong, nonatomic) UIDatePicker *datePicker;

- (IBAction) entryDatePickerValueChanged:(UIDatePicker *)picker;
- (IBAction) dateButtonPressed:(id)sender;
- (void) setDate:(NSString*)date;

@end
