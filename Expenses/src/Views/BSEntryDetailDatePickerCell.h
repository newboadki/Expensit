//
//  BSEntryDetailDatePickerCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 06/09/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailCell.h"

@interface BSEntryDetailDatePickerCell : BSEntryDetailCell
- (IBAction) entryDatePickerValueChanged:(UIDatePicker *)picker;
- (void) setup;
@end
