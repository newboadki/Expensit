//
//  DateHelper.m
//  ExpensesTests
//
//  Created by Borja Arias Drake on 21/09/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import "DailyTestHelper.h"


@implementation DailyTestHelper

+ (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *day = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[2]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", day,  [NSString stringWithFormat:@"%@/%@", month, year]];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}
@end
