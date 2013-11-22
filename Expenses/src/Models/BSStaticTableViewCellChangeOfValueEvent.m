//
//  BSTableViewCellChangeOfValueEvent.m
//  Expenses
//
//  Created by Borja Arias Drake on 09/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCellChangeOfValueEvent.h"

@implementation BSStaticTableViewCellChangeOfValueEvent

- (instancetype)initWithNewValue:(id)value forPropertyName:(NSString *)propertyName
{
    self = [super init];
    
    if (self)
    {
        _value = value;
    }
    
    return self;
}

@end
