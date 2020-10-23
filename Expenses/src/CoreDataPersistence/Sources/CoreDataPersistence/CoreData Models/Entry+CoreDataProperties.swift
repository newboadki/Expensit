//
//  Entry+CoreDataProperties.swift
//  
//
//  Created by Borja Arias Drake on 12/07/2020.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func entryFetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var date: Date?
    @NSManaged public var day: NSNumber?
    @NSManaged public var dayMonthYear: String?
    @NSManaged public var desc: String?
    @NSManaged public var hour: NSNumber?
    @NSManaged public var isAmountNegative: NSNumber
    @NSManaged public var minute: NSNumber?
    @NSManaged public var month: NSNumber?
    @NSManaged public var monthYear: String?
    @NSManaged public var second: NSNumber?
    @NSManaged public var value: NSDecimalNumber
    @NSManaged public var year: NSNumber?
    @NSManaged public var yearMonthDay: String?
    @NSManaged public var tag: Tag?
    @NSManaged public var currencyCode: String
    @NSManaged public var exchangeRateToBaseCurrency: NSDecimalNumber

}

//- (NSString*) dayAndMonth
//{
//    return [NSString stringWithFormat:@"%d/%d", [self.day intValue], [self.month intValue]];
//}
//
//- (void)setDate:(NSDate *)date
//{
//    if (_date != date)
//    {
//        _date = date;
//        self.day = [NSNumber numberWithInteger:[DateConversion dayOfDateUsingCurrentCalendar:self.date]];
//        self.month = [NSNumber numberWithInteger:[DateConversion monthOfDateUsingCurrentCalendar:self.date]];
//        self.year = [NSNumber numberWithInteger:[DateConversion yearOfDateUsingCurrentCalendar:self.date]];
//        self.hour = [NSNumber numberWithInteger:[DateConversion hourOfDateUsingCurrentCalendar:self.date]];
//        self.minute = [NSNumber numberWithInteger:[DateConversion minuteOfDateUsingCurrentCalendar:self.date]];
//        self.second = [NSNumber numberWithInteger:[DateConversion secondOfDateUsingCurrentCalendar:self.date]];
//        self.monthYear = [NSString stringWithFormat:@"%@/%@", [self.month stringValue], [self.year stringValue]];
//        self.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [self.day stringValue], [self.month stringValue], [self.year stringValue]];
//        self.yearMonthDay = [NSString stringWithFormat:@"%@/%@/%@", [self.year stringValue], [self.month stringValue], [self.day stringValue]];
//    }
//}
//
//#pragma mark - Validation
//
//-(BOOL)validateValue:(id *)ioValue error:(NSError **)outError {
//
//    NSDecimalNumber *amount = (NSDecimalNumber *)(*ioValue);
//    BOOL valid = (([amount compare:@0] != NSOrderedSame) && (![amount isEqualToNumber:[NSDecimalNumber notANumber]]));
//
//
//    NSString *errorStr = NSLocalizedStringFromTable(
//                                                    @"Amount can't be zero", @"Entry",
//                                                    @"validation: zero amount error");
//    NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : errorStr };
//    NSError *error = [[NSError alloc] initWithDomain:@"EntryErrorDomain"
//                                                code:1
//                                            userInfo:userInfoDict];
//    *outError = error;
//
//    return valid;
//}
//
