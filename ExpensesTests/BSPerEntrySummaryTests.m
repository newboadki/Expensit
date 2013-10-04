//
//  BSPerEntrySummaryTests.m
//  Expenses
//
//  Created by Borja Arias Drake on 30/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSIndividualExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Entry.h"

@interface BSPerEntrySummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSIndividualExpensesSummaryViewController *individualEntryViewController;
@end

@implementation BSPerEntrySummaryTests

- (void)setUp
{
    [super setUp];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    [self.coreDataStackHelper destroySQLPersistentStoreCoordinator];
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    self.individualEntryViewController = [[BSIndividualExpensesSummaryViewController alloc] init];
    self.individualEntryViewController.coreDataStackHelper = self.coreDataStackHelper;
    self.individualEntryViewController.coreDataController = self.coreDataController;
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Food and drinks" value:@"-20.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Salary" value:@"100.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10"];
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"21.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"-7.0"];
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"-5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10"];
}


- (NSArray*) entryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *day = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[2]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %@ AND month = %@ AND year = %@ ", day,  month, year];
    
    return [results filteredArrayUsingPredicate:predicate];
}


- (void)tearDown
{
    self.coreDataStackHelper = nil;
    self.individualEntryViewController = nil;
    [super tearDown];
}

- (void) testIndividualEntriesCalculations
{
    NSArray *entries = self.individualEntryViewController.fetchedResultsController.fetchedObjects;
    XCTAssertTrue([entries count] == 10, @"Monthly results don't have the right number of monthly entries.");
    
    XCTAssertTrue([[self entryForDate:@"13/01/2013" fromArray:entries] count] == 2, @"01/2013's sum is Incorrect");
    XCTAssertTrue([[self entryForDate:@"05/03/2013" fromArray:entries] count] == 2, @"02/2013's sum is Incorrect");
    
    XCTAssertTrue([[self entryForDate:@"02/01/2012" fromArray:entries] count] == 1, @"01/2012's sum is Incorrect");
    XCTAssertTrue([[self entryForDate:@"03/03/2012" fromArray:entries] count] == 2, @"02/2012's sum is Incorrect");
    
    XCTAssertTrue([[self entryForDate:@"19/06/2011" fromArray:entries] count] == 2, @"01/2011's sum is Incorrect");
    XCTAssertTrue([[self entryForDate:@"21/12/2011" fromArray:entries] count] == 1, @"02/2011's sum is Incorrect");
}

@end
