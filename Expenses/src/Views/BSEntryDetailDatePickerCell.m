//
//  BSEntryDetailDatePickerCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 06/09/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailDatePickerCell.h"
#import "DateTimeHelper.h"
@implementation BSEntryDetailDatePickerCell

@synthesize entryModel = _entryModel;


- (IBAction) entryDatePickerValueChanged:(UIDatePicker *)picker
{
    UIDatePicker *datePicker = (UIDatePicker *)self.control;
    self.entryModel.date = datePicker.date;
    self.entryModel.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:self.entryModel.date]];
    self.entryModel.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:self.entryModel.date]];
    self.entryModel.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:self.entryModel.date]];
    self.entryModel.monthYear = [NSString stringWithFormat:@"%@/%@", [self.entryModel.month stringValue], [self.entryModel.year stringValue]];
    self.entryModel.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [self.entryModel.day stringValue], [self.entryModel.month stringValue], [self.entryModel.year stringValue]];
    self.entryModel.yearMonthDay = [NSString stringWithFormat:@"%@/%@/%@", [self.entryModel.year stringValue], [self.entryModel.month stringValue], [self.entryModel.day stringValue]];

    [self.delegate cell:self changedValue:datePicker.date];
}

- (void) setEntryModel:(Entry *)entryModel
{
    if (_entryModel != entryModel)
    {
        _entryModel = entryModel;
        UIDatePicker *datePicker = (UIDatePicker *)self.control;
        NSDate *date = [self.entryModel valueForKey:self.modelProperty];
        if (date)
        {
            [datePicker setDate:date];
        }
        else
        {
            [datePicker setDate:[NSDate date]];
        }
    }
}

- (void) setup {
    if (![self.control superview]) {
        [self.control addTarget:self action:@selector(entryDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.control];    
    }
    
}

@end
