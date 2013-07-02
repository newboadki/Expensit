//
//  Entry.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSDate  * date;
@property (nonatomic, retain) NSDecimalNumber * value;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *monthYear;
@property (nonatomic, retain) NSString *dayMonthYear;

- (NSString*) dayAndMonth;

@end
