//
//  BSDateToDatePickerCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 15/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSDateToDatePickerCellConvertor.h"
#import "DateTimeHelper.h"

static NSDateFormatter *_dateFormatter;

@implementation BSDateToDatePickerCellConvertor

- (id)cellValueForModelValue:(NSString *)modelValue
{
    return [[self dateFormatter] dateFromString:modelValue];
}


- (id)modelValueForCellValue:(NSDate *)cellValue
{
    return [[self dateFormatter] stringFromDate:cellValue];
}


- (NSString *)cellStringValueValueForModelValue:(NSString *)modelValue
{
    // Beucase the value comes from a viewModel and it is formatted already
    return modelValue;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter)
    {
        return _dateFormatter;
    }
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = DEFAULT_DATE_FORMAT;

    return _dateFormatter;
}

@end
