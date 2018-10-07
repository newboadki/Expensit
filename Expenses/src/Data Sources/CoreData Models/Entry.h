//
//  Entry.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tag.h"

@interface Entry : NSManagedObject

@property (nonatomic, strong) NSNumber * day;
@property (nonatomic, strong) NSNumber * month;
@property (nonatomic, strong) NSNumber * year;
@property (nonatomic, strong) NSDate  * date;
@property (nonatomic, strong) NSDecimalNumber * value;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *monthYear;
@property (nonatomic, strong) NSString *dayMonthYear;
@property (nonatomic, strong) NSString *yearMonthDay;
@property (nonatomic, strong) Tag *tag;
@property (nonatomic, strong) NSNumber *isAmountNegative;

- (NSString*) dayAndMonth;

@end
