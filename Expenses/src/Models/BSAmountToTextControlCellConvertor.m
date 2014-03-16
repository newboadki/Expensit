//
//  BSAmountToTextControlCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 11/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAmountToTextControlCellConvertor.h"
#import <objc/runtime.h>

@implementation BSAmountToTextControlCellConvertor

- (id)cellValueForModelValue:(id)modelValue
{
    NSString *cellValue = nil;
    NSDecimalNumber *number = modelValue;
    
    switch ([number compare:@0])
    {
        case NSOrderedSame:
        case NSOrderedAscending:
        {
            number = [number decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
            break;
        }
        case NSOrderedDescending:
        default:
            break;
    }

    cellValue = [number stringValue];

    
    if ([cellValue isEqualToString:@"0"])
    {
        cellValue = @"";
    }
    
    if (cellValue == nil)
    {
        cellValue = @"";
    }
    
    return cellValue;
}


- (id)modelValueForCellValue:(id)cellValue
{
    NSString *stringValue = [cellValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
    return [NSDecimalNumber decimalNumberWithString:stringValue];
}


- (NSString *)cellStringValueValueForModelValue:(id)modelValue
{
    return nil;
}

@end