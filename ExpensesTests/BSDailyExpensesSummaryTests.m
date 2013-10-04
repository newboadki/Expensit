//
//  BSDailyExpensesSummaryTests.m
//  Expenses
//
//  Created by Borja Arias Drake on 30/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSDailyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import <OCMock/OCMock.h>

@interface BSDailyExpensesSummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSDailyExpensesSummaryViewController *dailyViewController;
@property (strong, nonatomic) NSString *expectedVisibleSectionName;
@end

@implementation BSDailyExpensesSummaryTests

- (void)setUp
{
    [super setUp];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    [self.coreDataStackHelper destroySQLPersistentStoreCoordinator];
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    self.dailyViewController = [[BSDailyExpensesSummaryViewController alloc] init];
    self.dailyViewController.coreDataStackHelper = self.coreDataStackHelper;
        
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


- (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *day = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[2]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", day,  [NSString stringWithFormat:@"%@/%@", month, year]];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}


- (void)tearDown
{
    self.coreDataStackHelper = nil;
    self.dailyViewController = nil;
    [super tearDown];
}

- (void) testDailyCalculations
{
    NSArray *dailyResults = self.dailyViewController.fetchedResultsController.fetchedObjects;
    XCTAssertTrue([dailyResults count] == 6, @"Daily results don't have the right number of Daily entries.");
        
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"13/01/2013" fromArray:dailyResults] valueForKey:@"dailySum"], @(80), @"01/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"05/03/2013" fromArray:dailyResults] valueForKey:@"dailySum"], @(-15), @"02/2013's sum is Incorrect");
    
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"02/01/2012" fromArray:dailyResults] valueForKey:@"dailySum"], @(-20.5), @"01/2012's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"03/03/2012" fromArray:dailyResults] valueForKey:@"dailySum"], @(14), @"02/2012's sum is Incorrect");
    
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"19/06/2011" fromArray:dailyResults] valueForKey:@"dailySum"], @(7), @"01/2011's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"21/12/2011" fromArray:dailyResults] valueForKey:@"dailySum"], @(-10), @"02/2011's sum is Incorrect");
}


- (void) testGraphDailySurplusCalculations
{
    self.expectedVisibleSectionName = @"1/2013";
    id mock = [OCMockObject partialMockForObject:self.dailyViewController];
    [[[mock stub] andCall:@selector(visibleSectionNameMock) onObject:self] visibleSectionName];
    
    NSArray *dailyResults = [self.dailyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    
    // Jan 2013
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(100), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(13), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"13/1/2013", @"2013's Feb sum is Incorrect");

    // March 2013
    self.expectedVisibleSectionName = @"3/2013";
    dailyResults = [self.dailyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([dailyResults count] == 0, @"Daily results don't have the right number of month entries.");
    
    // Jan 2012
    self.expectedVisibleSectionName = @"1/2012";
    dailyResults = [self.dailyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([dailyResults count] == 0, @"Daily results don't have the right number of month entries.");

    // March 2012
    self.expectedVisibleSectionName = @"3/2012";
    dailyResults = [self.dailyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");

    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(21), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(3), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"3/3/2012", @"2013's Feb sum is Incorrect");
    
    // Jun 2011
    self.expectedVisibleSectionName = @"6/2011";
    dailyResults = [self.dailyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    

    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(12), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(19), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"19/6/2011", @"2013's Feb sum is Incorrect");
    // Dec 2011
    self.expectedVisibleSectionName = @"12/2011";
    dailyResults = [self.dailyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([dailyResults count] == 0, @"Daily results don't have the right number of month entries.");
    
}


- (void) testGraphDailyExpensesCalculations
{
    self.expectedVisibleSectionName = @"1/2013";
    id mock = [OCMockObject partialMockForObject:self.dailyViewController];
    [[[mock stub] andCall:@selector(visibleSectionNameMock) onObject:self] visibleSectionName];
    
    NSArray *dailyResults = [self.dailyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    
    
    // Jan 2013
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(-20), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(13), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"13/1/2013", @"2013's Feb sum is Incorrect");
    
    // March 2013
    self.expectedVisibleSectionName = @"3/2013";
    dailyResults = [self.dailyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(-15), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"5/3/2013", @"2013's Feb sum is Incorrect");
    
    // Jan 2012
    self.expectedVisibleSectionName = @"1/2012";
    dailyResults = [self.dailyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(-20.5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(2), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"2/1/2012", @"2013's Feb sum is Incorrect");
    
    // March 2012
    self.expectedVisibleSectionName = @"3/2012";
    dailyResults = [self.dailyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(-7), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(3), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"3/3/2012", @"2013's Feb sum is Incorrect");
    
    // Jun 2011
    self.expectedVisibleSectionName = @"6/2011";
    dailyResults = [self.dailyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(-5), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(19), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"19/6/2011", @"2013's Feb sum is Incorrect");

    // Dec 2011
    self.expectedVisibleSectionName = @"12/2011";
    dailyResults = [self.dailyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([dailyResults count] == 1, @"Daily results don't have the right number of month entries.");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dailySum"], @(-10), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"day"], @(21), @"2013's Feb sum is Incorrect");
    XCTAssertEqualObjects([dailyResults[0] valueForKey:@"dayMonthYear"], @"21/12/2011", @"2013's Feb sum is Incorrect");
}


- (NSString *)visibleSectionNameMock {
    return self.expectedVisibleSectionName;
}


@end
