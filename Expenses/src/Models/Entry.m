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
@synthesize date = _date;
@dynamic value;
@dynamic desc;
@dynamic monthYear, dayMonthYear, yearMonthDay;
@dynamic tag;
@dynamic isAmountNegative;

- (NSString*) dayAndMonth
{
    return [NSString stringWithFormat:@"%d/%d", [self.day intValue], [self.month intValue]];
}

- (void)setDate:(NSDate *)date
{
    if (_date != date)
    {
        _date = date;
        self.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:self.date]];
        self.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:self.date]];
        self.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:self.date]];
        self.monthYear = [NSString stringWithFormat:@"%@/%@", [self.month stringValue], [self.year stringValue]];
        self.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [self.day stringValue], [self.month stringValue], [self.year stringValue]];
        self.yearMonthDay = [NSString stringWithFormat:@"%@/%@/%@", [self.year stringValue], [self.month stringValue], [self.day stringValue]];
    }
}

#pragma mark - Validation

-(BOOL)validateValue:(id *)ioValue error:(NSError **)outError {
    
    NSDecimalNumber *amount = (NSDecimalNumber *)(*ioValue);
    BOOL valid = (([amount compare:@0] != NSOrderedSame) && (![amount isEqualToNumber:[NSDecimalNumber notANumber]]));

    
    NSString *errorStr = NSLocalizedStringFromTable(
                                                    @"Amount can't be zero", @"Entry",
                                                    @"validation: zero amount error");
    NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : errorStr };
    NSError *error = [[NSError alloc] initWithDomain:@"EntryErrorDomain"
                                                code:1
                                            userInfo:userInfoDict];
    *outError = error;
    
    return valid;
}

@end
