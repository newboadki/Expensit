//
//  BSEntryTypeToSegmentedControlCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryTypeToSegmentedControlCellConvertor.h"

@implementation BSEntryTypeToSegmentedControlCellConvertor


- (id)cellValueForModelValue:(id)modelValue
{
    id cellValue = nil;
    
    NSNumber *modelValueNumber = (NSNumber *)modelValue;
    BOOL isAmountNegative = [modelValueNumber boolValue];
    if (!modelValueNumber || isAmountNegative)
    {
        cellValue = @(0); // Expense
    } else {
        cellValue = @(1); // Benefit
    }
    
    return cellValue;
}

- (id)modelValueForCellValue:(id)cellValue
{
    id modelValue = nil;
    NSNumber *indexNumber = (NSNumber *)cellValue;
    NSInteger index = [indexNumber integerValue];
    
    switch (index) {
        case 0:
            modelValue = @(YES); // Expense
            break;
        case 1:
            modelValue = @(NO); // benefit
            break;
            
        default:
            break;
    }
    
    return modelValue;
}

- (NSString *)cellStringValueValueForModelValue:(id)modelValue
{
    return nil;
}

@end
