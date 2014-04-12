//
//  BSYearlyExpensesSummaryTests.m
//  Expenses
//
//  Created by Borja Arias Drake on 27/09/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSYearlyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"
#import "OCMock/Headers/OCMock/OCMock.h"

@interface BSYearlyExpensesSummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSYearlyExpensesSummaryViewController *yearlyViewController;
@end

@implementation BSYearlyExpensesSummaryTests

- (void)setUp
{
    [super setUp];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    [self.coreDataStackHelper destroySQLPersistentStoreCoordinator];
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    self.yearlyViewController = [[BSYearlyExpensesSummaryViewController alloc] init];
    self.yearlyViewController.collectionView = nil;
    self.yearlyViewController.collectionView = nil;
    self.yearlyViewController.coreDataStackHelper = self.coreDataStackHelper;
    self.yearlyViewController.coreDataController = self.coreDataController;
    
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"100.0" category:nil];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1" category:nil];
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year = %@", (NSNumber *)[NSDecimalNumber decimalNumberWithString:dateString]];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}


- (void)tearDown
{
    self.coreDataStackHelper = nil;
    self.yearlyViewController = nil;
    [super tearDown];
}

- (void) testYearlyCalculationsWithNoFilter
{
    NSArray *yearlyResults = self.yearlyViewController.fetchedResultsController.fetchedObjects;
    XCTAssertTrue([yearlyResults count] == 3, @"Yearly results don't have the right number of yearly entries.");
    
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"2013" fromArray:yearlyResults] valueForKey:@"yearlySum"], @(-6.9), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"2012" fromArray:yearlyResults] valueForKey:@"yearlySum"], @(398.5), @"02/2013's sum is Incorrect");
    XCTAssertEqualObjects([[self resultDictionaryForDate:@"2011" fromArray:yearlyResults] valueForKey:@"yearlySum"], @(249.5), @"03/2013's sum is Incorrect");
}

//- (void) testYearlyCalculationsWithFilter
//{
//    
//    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
//    [self.coreDataController createTags:tags];
//    Tag* foodTag = [self.coreDataController tagForName:@"Food"];
//    Tag* billsTag = [self.coreDataController tagForName:@"Bills"];
//    Tag* travelTag = [self.coreDataController tagForName:@"Travel"];
//    
//    
//    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
//    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
//    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
//    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
//    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
//    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];
//
//    
//    
//    
//
//    [self.yearlyViewController filterChangedToCategory:foodTag];
//    NSArray *yearlyResults = self.yearlyViewController.fetchedResultsController.fetchedObjects;
//    XCTAssertTrue([yearlyResults count] == 2, @"Yearly results don't have the right number of yearly entries.");
//    
//    XCTAssertEqualObjects([[self resultDictionaryForDate:@"2012" fromArray:yearlyResults] valueForKey:@"yearlySum"], @(-5), @"2012's sum is Incorrect");
//    XCTAssertEqualObjects([[self resultDictionaryForDate:@"2011" fromArray:yearlyResults] valueForKey:@"yearlySum"], @(-75), @"2011's sum is Incorrect");
//}




- (void) testGraphYearlySurplusCalculations
{
    NSArray *yearlyResults = [self.yearlyViewController performSelector:@selector(graphSurplusResults)];
    XCTAssertTrue([yearlyResults count] == 3, @"Yearly results don't have the right number of yearly entries.");
    
    
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"yearlySum"], @(306.5), @"2011's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"year"], @(2011), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"yearlySum"], @(470), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"year"], @(2012), @"2012's sum is Incorrect");

    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"yearlySum"], @(254), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"year"], @(2013), @"2013's sum is Incorrect");

}


- (void) testGraphYearlyExpensesCalculations
{
    NSArray *yearlyResults = [self.yearlyViewController performSelector:@selector(graphExpensesResults)];
    XCTAssertTrue([yearlyResults count] == 3, @"Yearly results don't have the right number of yearly entries.");
    
    
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"yearlySum"], @(-57), @"2011's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[0] valueForKey:@"year"], @(2011), @"2011's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"yearlySum"], @(-71.5), @"2012's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[1] valueForKey:@"year"], @(2012), @"2012's sum is Incorrect");
    
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"yearlySum"], @(-260.9), @"2013's sum is Incorrect");
    XCTAssertEqualObjects([yearlyResults[2] valueForKey:@"year"], @(2013), @"2013's sum is Incorrect");
    
}


@end
