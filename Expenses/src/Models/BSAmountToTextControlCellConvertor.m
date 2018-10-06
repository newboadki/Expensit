//
//  BSAmountToTextControlCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 11/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAmountToTextControlCellConvertor.h"
#import <objc/runtime.h>
#import "BSCurrencyHelper.h"

@implementation BSAmountToTextControlCellConvertor

- (id)cellValueForModelValue:(id)modelValue
{
//    NSString *cellValue = nil;
    NSString *numberString = modelValue;
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithDecimal:[[[BSCurrencyHelper amountFormatter] numberFromString:numberString] decimalValue]];
    NSString *formattedString = [[BSCurrencyHelper amountFormatter] stringFromNumber:number];
    return formattedString;
}


- (id)modelValueForCellValue:(id)cellValue
{
    NSNumber *number = [[BSCurrencyHelper amountFormatter] numberFromString:cellValue];
    if (number != nil)
    {
        // The number was a correctly formatted currency amount
        return cellValue;
    }
    else
    {
        // The number was an incorrectly formatted currency amount.
        // At the moment the textfield allows the user to delete everything even the currency symbol, which would make
        // [BSCurrencyHelper amountFormatter] numberFromString: fail
        NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:cellValue];
        return [[BSCurrencyHelper amountFormatter] stringFromNumber:decimalNumber];
    }
}


- (NSString *)cellStringValueValueForModelValue:(id)modelValue
{
    return nil;
}

@end
