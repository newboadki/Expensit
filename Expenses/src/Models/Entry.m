//
//  Entry.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "Entry.h"


@implementation Entry

@dynamic date;
@dynamic value;
@dynamic desc;

- (NSInteger) month
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    return [components month];
}

@end
