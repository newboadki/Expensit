//
//  DateHelper.h
//  ExpensesTests
//
//  Created by Borja Arias Drake on 21/09/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyTestHelper : NSObject
+ (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results;
@end

