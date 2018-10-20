//
//  BSTagToSegmentedControlCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSTagToSegmentedControlCellConvertor.h"
#import "BSCoreDataController.h"

@implementation BSTagToSegmentedControlCellConvertor

- (id)cellValueForModelValue:(id)modelValue
{
    return [self cellStringValueValueForModelValue:modelValue];
}


- (id)modelValueForCellValue:(NSString *)cellValue
{
    return cellValue;
}


- (NSString *)cellStringValueValueForModelValue:(NSString *)modelValue
{
    return modelValue;
}

@end
