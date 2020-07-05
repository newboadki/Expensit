//
//  BSCurrencyHelper.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCurrencyHelper.h"

static NSNumberFormatter *_amountFormatter = nil;

@implementation BSCurrencyHelper

+ (NSNumberFormatter*) amountFormatter
{
    if (!_amountFormatter)
    {
        _amountFormatter = [[NSNumberFormatter alloc] init];
        _amountFormatter.generatesDecimalNumbers = YES;
        [_amountFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        //[_amountFormatter setMaximumFractionDigits:0];
        [_amountFormatter setLocale:[NSLocale currentLocale]];        
    }
    
    return _amountFormatter;
}

@end
