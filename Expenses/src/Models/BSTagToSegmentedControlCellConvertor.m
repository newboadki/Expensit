//
//  BSTagToSegmentedControlCellConvertor.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSTagToSegmentedControlCellConvertor.h"
#import "Tag.h"
#import "BSCoreDataController.h"

@implementation BSTagToSegmentedControlCellConvertor

- (id)cellValueForModelValue:(id)modelValue
{
    id cellValue = nil;
    
    Tag *tag = (Tag*)modelValue;
    if (!tag)
    {
        tag = [self.coreDataController tagForName:@"Other"];
    }

    NSArray *allTags = [self.coreDataController allTags];
    NSInteger index = [allTags indexOfObject:tag];
    cellValue = @(index);
    
    return cellValue;
}


- (id)modelValueForCellValue:(id)cellValue
{
    id modelValue = nil;
    
    NSNumber *indexNumber = (NSNumber *)cellValue;
    NSInteger index = [indexNumber integerValue];
    NSArray *allTags = [self.coreDataController allTags];
    Tag *tag = [allTags objectAtIndex:index];
    modelValue = tag;
    
    return modelValue;
}


- (NSString *)cellStringValueValueForModelValue:(id)modelValue
{
    return nil;
}

@end
