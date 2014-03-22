//
//  BSDateToDatePickerCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 15/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSDateToDatePickerCellConvertor.h"

static NSDateFormatter *_dateFormatter;

@implementation BSDateToDatePickerCellConvertor

- (id)cellValueForModelValue:(id)modelValue
{
    return modelValue;
}


- (id)modelValueForCellValue:(id)cellValue
{
    return cellValue;
}


- (NSString *)cellStringValueValueForModelValue:(id)modelValue
{
    NSDate* date = nil;
    
    if (modelValue)
    {
        date = modelValue;
    }
    else
    {
        date = [NSDate date];
    }

    return [[self dateFormatter] stringFromDate:date];
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter)
    {
        return _dateFormatter;
    }
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"dd MMM yyyy";

    return _dateFormatter;
}

@end
