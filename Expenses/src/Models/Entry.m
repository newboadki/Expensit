//
//  Entry.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "Entry.h"
#import "DateTimeHelper.h"


@implementation Entry

@dynamic day, month, year;
@dynamic date;
@dynamic value;
@dynamic desc;

- (NSString*) dayMonthYearString
{
    return [NSString stringWithFormat:@"%d/%d/%d", [self.day intValue], [self.month intValue], [self.year intValue]];
}

- (NSString*) dayAndMonth
{
    return [NSString stringWithFormat:@"%d/%d", [self.day intValue], [self.month intValue]];
}


@end
