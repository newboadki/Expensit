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
#import "OCMock/Headers/OCMock/OCMock.h"

@interface BSMonthlyExpensesSummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSMonthlyExpensesSummaryViewController *monthlyViewController;
@property (strong, nonatomic) NSString *expectedVisibleSectionName;
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
    
    // 2013
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"9.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"-90.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"23.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"-5.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"-12.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"18.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"3.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"2.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"10.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1" category:nil];
    
    // 2012
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    
    // 2011
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"1" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"2" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-1" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:nil];
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
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"02/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(42), @"02/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"03/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-11), @"03/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"04/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(33), @"04/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"05/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"05/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"06/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-131), @"06/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"07/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-20.5), @"07/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"08/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-33.5), @"08/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"09/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-2.5), @"09/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"10/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(-7.8), @"10/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"11/2013" fromArray:monthlyResults] valueForKey:@"monthlySum"], @(33), @"11/2013's sum is Incorrect");
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
    self.expectedVisibleSectionName = @"2013";
    id mock = [OCMockObject partialMockForObject:self.monthlyViewController];
    [[[mock stub] andCall:@selector(visibleSectionNameMock) onObject:self] visibleSectionName];
    
    NSArray *monthlyResults = [self.monthlyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([monthlyResults count] == 4, @"Monthly results don't have the right number of month entries.");
    
    // 2013
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"monthlySum"], @(132), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"month"], @(2), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"monthlySum"], @(4), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"year"], @(2013), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"month"], @(3), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"monthlySum"], @(50), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"year"], @(2013), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"month"], @(4), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"monthlySum"], @(33), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"year"], @(2013), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"month"], @(11), @"2011's sum is Incorrect");
    
    // 2012
    self.expectedVisibleSectionName = @"2012";
    monthlyResults = [self.monthlyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([monthlyResults count] == 6, @"Monthly results don't have the right number of month entries.");
    
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"monthlySum"], @(21), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"year"], @(2012), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"month"], @(3), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"monthlySum"], @(50.5), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"year"], @(2012), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"month"], @(4), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"monthlySum"], @(37), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"year"], @(2012), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"month"], @(7), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"monthlySum"], @(50.5), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"year"], @(2012), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"month"], @(8), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"monthlySum"], @(260.5), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"year"], @(2012), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"month"], @(11), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[5] valueForKey:@"monthlySum"], @(50.5), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[5] valueForKey:@"year"], @(2012), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[5] valueForKey:@"month"], @(12), @"2011's sum is Incorrect");
    
    // 2011
    self.expectedVisibleSectionName = @"2011";
    monthlyResults = [self.monthlyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([monthlyResults count] == 4, @"Monthly results don't have the right number of month entries.");
    
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"monthlySum"], @(220.5), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"month"], @(2), @"2011's Feb sum is Incorrect");

    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"monthlySum"], @(3), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"month"], @(3), @"2011's Feb sum is Incorrect");

    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"monthlySum"], @(50.5), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"month"], @(4), @"2011's Feb sum is Incorrect");

    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"monthlySum"], @(32.5), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"month"], @(6), @"2011's Feb sum is Incorrect");
}


- (void) testGraphMonthlyExpensesCalculations
{
    self.expectedVisibleSectionName = @"2013";
    id mock = [OCMockObject partialMockForObject:self.monthlyViewController];
    [[[mock stub] andCall:@selector(visibleSectionNameMock) onObject:self] visibleSectionName];
    
    NSArray *monthlyResults = [self.monthlyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([monthlyResults count] == 11, @"Monthly results don't have the right number of month entries.");
    
    
    // 2013
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"monthlySum"], @(-20), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"month"], @(1), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"monthlySum"], @(-90), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"month"], @(2), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"monthlySum"], @(-15), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"month"], @(3), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"monthlySum"], @(-17), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"month"], @(4), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"monthlySum"], @(-20.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"month"], @(5), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[5] valueForKey:@"monthlySum"], @(-131), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[5] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[5] valueForKey:@"month"], @(6), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[6] valueForKey:@"monthlySum"], @(-20.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[6] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[6] valueForKey:@"month"], @(7), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[7] valueForKey:@"monthlySum"], @(-33.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[7] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[7] valueForKey:@"month"], @(8), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[8] valueForKey:@"monthlySum"], @(-2.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[8] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[8] valueForKey:@"month"], @(9), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[9] valueForKey:@"monthlySum"], @(-7.8), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[9] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[9] valueForKey:@"month"], @(10), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[10] valueForKey:@"monthlySum"], @(-10.1), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[10] valueForKey:@"year"], @(2013), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[10] valueForKey:@"month"], @(12), @"2013's Feb sum is Incorrect");
    
    // 2012
    self.expectedVisibleSectionName = @"2012";
    monthlyResults = [self.monthlyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([monthlyResults count] == 4, @"Monthly results don't have the right number of month entries.");
    
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"monthlySum"], @(-20.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"year"], @(2012), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"month"], @(1), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"monthlySum"], @(-12), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"year"], @(2012), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"month"], @(3), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"monthlySum"], @(-18.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"year"], @(2012), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"month"], @(7), @"2013's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"monthlySum"], @(-20.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"year"], @(2012), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"month"], @(9), @"2013's Feb sum is Incorrect");
    
    // 2011
    self.expectedVisibleSectionName = @"2011";
    monthlyResults = [self.monthlyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([monthlyResults count] == 5, @"Monthly results don't have the right number of month entries.");
    
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"monthlySum"], @(-20.5), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[0] valueForKey:@"month"], @(1), @"2011's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"monthlySum"], @(-1), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[1] valueForKey:@"month"], @(3), @"2011's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"monthlySum"], @(-20.5), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[2] valueForKey:@"month"], @(5), @"2011's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"monthlySum"], @(-5), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[3] valueForKey:@"month"], @(7), @"2011's Feb sum is Incorrect");
    
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"monthlySum"], @(-10), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"year"], @(2011), @"2011's Feb sum is Incorrect");
    XCTAssertEqualObjects([monthlyResults[4] valueForKey:@"month"], @(12), @"2011's Feb sum is Incorrect");

}


- (NSString *)visibleSectionNameMock {
    return self.expectedVisibleSectionName;
}

@end
