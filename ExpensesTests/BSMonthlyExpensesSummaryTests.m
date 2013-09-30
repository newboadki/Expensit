//
//  BSMonthlyExpensesSummaryTests.m
//  Expenses
//
//  Created by Borja Arias Drake on 30/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSMonthlyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"

@interface BSMonthlyExpensesSummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSMonthlyExpensesSummaryViewController *monthlyViewController;
@end

@implementation BSMonthlyExpensesSummaryTests

- (void)setUp
{
    [super setUp];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    [self.coreDataStackHelper destroySQLPersistentStoreCoordinator];
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    self.monthlyViewController = [[BSMonthlyExpensesSummaryViewController alloc] init];
    self.monthlyViewController.coreDataStackHelper = self.coreDataStackHelper;
    self.monthlyViewController.coreDataController = self.coreDataController;
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"100.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1"];
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5"];

    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"1"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"2"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-1"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10"];
}

                                                         
- (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"month = %@ AND year = %@", month, year];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}
   
                                                         
- (void)tearDown
{
    self.coreDataStackHelper = nil;
    self.monthlyViewController = nil;
    [super tearDown];
}

- (void) testMonthlyCalculations
{
    NSArray *monthlyResults = self.monthlyViewController.fetchedResultsController.fetchedObjects;
    XCTAssertTrue([monthlyResults count] == 12 + 8 + 8, @"Monthly results don't have the right number of monthly entries.");
    
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"01/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20), @"01/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"02/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(100), @"02/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"03/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-11), @"03/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"04/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(50), @"04/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"05/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"05/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"06/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-131), @"06/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"07/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"07/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"08/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-33.5), @"08/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"09/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-2.5), @"09/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"10/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-7.8), @"10/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"11/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(100), @"11/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"12/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-10.1), @"12/2013's sum is Incorrect");
    
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"01/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"01/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"03/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(9), @"02/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"04/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(50.5), @"04/2012s sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"07/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(18.5), @"07/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"08/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(50.5), @"08/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"09/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"09/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"11/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(260.5), @"11/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"12/2012" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(50.5), @"12/2012's sum is Incorrect");

    XCTAssertEqualObjects([[self resultDictionaryForDate:@"01/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"01/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"02/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(220.5), @"02/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"03/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(2), @"03/2011s sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"04/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(50.5), @"04/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"05/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"05/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"06/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(32.5), @"06/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"07/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-5), @"11/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"12/2011" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-10), @"12/2011's sum is Incorrect");
}

- (void) testGraphMonthlySurplusCalculations
{
    NSArray *yearlyResults = [self.monthlyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([yearlyResults count] == 3, @"Yearly results don't have the right number of yearly entries.");
    
    
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"yearlySum"], @(306.5), @"2011's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"year"], @(2011), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"yearlySum"], @(470), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"year"], @(2012), @"2012's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"yearlySum"], @(254), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"year"], @(2013), @"2013's sum is Incorrect");
    
}


- (void) testGraphMonthlyExpensesCalculations
{
    NSArray *yearlyResults = [self.monthlyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([yearlyResults count] == 3, @"Yearly results don't have the right number of yearly entries.");
    
    
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"yearlySum"], @(-57), @"2011's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"year"], @(2011), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"yearlySum"], @(-71.5), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"year"], @(2012), @"2012's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"yearlySum"], @(-260.9), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"year"], @(2013), @"2013's sum is Incorrect");
    
}


@end
