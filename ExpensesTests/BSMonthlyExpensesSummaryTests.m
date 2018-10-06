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
#import "Expensit-Swift.h"
#import "Tag.h"

@interface BSMonthlyExpensesSummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSMonthlyExpensesSummaryViewController *monthlyViewController;
@property (strong, nonatomic) NSString *expectedVisibleSectionName;
@property (strong, nonatomic) BSShowMonthlyEntriesController *controller;
@property (strong, nonatomic) BSShowMonthlyEntriesPresenter *presenter;
@property (strong, nonatomic) BSCoreDataFetchController *fetchController;
@end

@implementation BSMonthlyExpensesSummaryTests

- (void)setUp
{
    [super setUp];
    
    [CoreDataStackHelper destroyAllExtensionsForSQLPersistentStoreCoordinatorWithName:@"myTestDataBase"];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                          resourceName:@"Expenses"
                                                                             extension:@"momd"
                                                                   persistentStoreName:@"myTestDataBase"];
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:self.coreDataStackHelper];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    self.monthlyViewController = [storyboard instantiateViewControllerWithIdentifier:@"BSMonthlyExpensesSummaryViewController"];

    self.fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:self.coreDataController];
    self.controller = [[BSShowMonthlyEntriesController alloc] initWithDataProvider:self.fetchController];
    self.presenter = [[BSShowMonthlyEntriesPresenter alloc] initWithShowEntriesUserInterface:self.monthlyViewController
                                                                       showEntriesController:self.controller];
    self.monthlyViewController.showEntriesPresenter = self.presenter;
    
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

- (void)tearDown
{
    [CoreDataStackHelper destroyAllExtensionsForSQLPersistentStoreCoordinatorWithName:@"myTestDataBase"];
    self.coreDataStackHelper = nil;
    self.monthlyViewController = nil;
    [super tearDown];
}


- (NSDictionary*) resultDictionaryForDate:(NSString*)dateString fromArray:(NSArray*)results
{
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    NSDecimalNumber *month = [NSDecimalNumber decimalNumberWithString:components[0]];
    NSDecimalNumber *year = [NSDecimalNumber decimalNumberWithString:components[1]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"month = %@ AND year = %@", month, year];
    
    return [[results filteredArrayUsingPredicate:predicate] lastObject];
}


- (void) testMonthlyCalculations
{
    [self.monthlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        XCTAssertTrue(sections.count == 3);
        
        BSDisplayExpensesSummarySection *sectionData_2011 = sections[0];
        XCTAssertTrue(sectionData_2011.entries.count == 12);
        XCTAssertTrue([sectionData_2011.title isEqualToString:@"2011"]);
        
        BSDisplayExpensesSummaryEntry * e1 = sectionData_2011.entries[0];
        XCTAssertTrue([e1.title isEqual:@"JAN"]);
        XCTAssertTrue([e1.value isEqual:@"-$20.50"]);

        BSDisplayExpensesSummaryEntry * e2 = sectionData_2011.entries[1];
        XCTAssertTrue([e2.title isEqual:@"FEB"]);
        XCTAssertTrue([e2.value isEqual:@"$220.50"]);

        BSDisplayExpensesSummaryEntry * e3 = sectionData_2011.entries[2];
        XCTAssertTrue([e3.title isEqual:@"MAR"]);
        XCTAssertTrue([e3.value isEqual:@"$2.00"]);

        BSDisplayExpensesSummaryEntry * e4 = sectionData_2011.entries[3];
        XCTAssertTrue([e4.title isEqual:@"APR"]);
        XCTAssertTrue([e4.value isEqual:@"$50.50"]);

        BSDisplayExpensesSummaryEntry * e5 = sectionData_2011.entries[4];
        XCTAssertTrue([e5.title isEqual:@"MAY"]);
        XCTAssertTrue([e5.value isEqual:@"-$20.50"]);

        BSDisplayExpensesSummaryEntry * e6 = sectionData_2011.entries[5];
        XCTAssertTrue([e6.title isEqual:@"JUN"]);
        XCTAssertTrue([e6.value isEqual:@"$32.50"]);

        BSDisplayExpensesSummaryEntry * e7 = sectionData_2011.entries[6];
        XCTAssertTrue([e7.title isEqual:@"JUL"]);
        XCTAssertTrue([e7.value isEqual:@"-$5.00"]);

        BSDisplayExpensesSummaryEntry * e8 = sectionData_2011.entries[7];
        XCTAssertTrue([e8.title isEqual:@"AUG"]);
        XCTAssertTrue([e8.value isEqual:@""]);

        BSDisplayExpensesSummaryEntry * e9 = sectionData_2011.entries[8];
        XCTAssertTrue([e9.title isEqual:@"SEP"]);
        XCTAssertTrue([e9.value isEqual:@""]);

        BSDisplayExpensesSummaryEntry * e10 = sectionData_2011.entries[9];
        XCTAssertTrue([e10.title isEqual:@"OCT"]);
        XCTAssertTrue([e10.value isEqual:@""]);

        BSDisplayExpensesSummaryEntry * e11 = sectionData_2011.entries[10];
        XCTAssertTrue([e11.title isEqual:@"NOV"]);
        XCTAssertTrue([e11.value isEqual:@""]);

        BSDisplayExpensesSummaryEntry * e12 = sectionData_2011.entries[11];
        XCTAssertTrue([e12.title isEqual:@"DEC"]);
        XCTAssertTrue([e12.value isEqual:@"-$10.00"]);

        
        BSDisplayExpensesSummarySection *sectionData_2012 = sections[1];
        XCTAssertTrue(sectionData_2012.entries.count == 12);
        XCTAssertTrue([sectionData_2012.title isEqualToString:@"2012"]);
        
        e1 = sectionData_2012.entries[0];
        XCTAssertTrue([e1.title isEqual:@"JAN"]);
        XCTAssertTrue([e1.value isEqual:@"-$20.50"]);
        
        e2 = sectionData_2012.entries[1];
        XCTAssertTrue([e2.title isEqual:@"FEB"]);
        XCTAssertTrue([e2.value isEqual:@""]);
        
        e3 = sectionData_2012.entries[2];
        XCTAssertTrue([e3.title isEqual:@"MAR"]);
        XCTAssertTrue([e3.value isEqual:@"$9.00"]);
        
        e4 = sectionData_2012.entries[3];
        XCTAssertTrue([e4.title isEqual:@"APR"]);
        XCTAssertTrue([e4.value isEqual:@"$50.50"]);
        
        e5 = sectionData_2012.entries[4];
        XCTAssertTrue([e5.title isEqual:@"MAY"]);
        XCTAssertTrue([e5.value isEqual:@""]);
        
        e6 = sectionData_2012.entries[5];
        XCTAssertTrue([e6.title isEqual:@"JUN"]);
        XCTAssertTrue([e6.value isEqual:@""]);
        
        e7 = sectionData_2012.entries[6];
        XCTAssertTrue([e7.title isEqual:@"JUL"]);
        XCTAssertTrue([e7.value isEqual:@"$18.50"]);
        
        e8 = sectionData_2012.entries[7];
        XCTAssertTrue([e8.title isEqual:@"AUG"]);
        XCTAssertTrue([e8.value isEqual:@"$50.50"]);
        
        e9 = sectionData_2012.entries[8];
        XCTAssertTrue([e9.title isEqual:@"SEP"]);
        XCTAssertTrue([e9.value isEqual:@"-$20.50"]);
        
        e10 = sectionData_2012.entries[9];
        XCTAssertTrue([e10.title isEqual:@"OCT"]);
        XCTAssertTrue([e10.value isEqual:@""]);
        
        e11 = sectionData_2012.entries[10];
        XCTAssertTrue([e11.title isEqual:@"NOV"]);
        XCTAssertTrue([e11.value isEqual:@"$260.50"]);
        
        e12 = sectionData_2012.entries[11];
        XCTAssertTrue([e12.title isEqual:@"DEC"]);
        XCTAssertTrue([e12.value isEqual:@"$50.50"]);

        BSDisplayExpensesSummarySection *sectionData_2013 = sections[2];
        XCTAssertTrue(sectionData_2013.entries.count == 12);
        XCTAssertTrue([sectionData_2013.title isEqualToString:@"2013"]);
        
        e1 = sectionData_2013.entries[0];
        XCTAssertTrue([e1.title isEqual:@"JAN"]);
        XCTAssertTrue([e1.value isEqual:@"-$20.00"]);
        
        e2 = sectionData_2013.entries[1];
        XCTAssertTrue([e2.title isEqual:@"FEB"]);
        XCTAssertTrue([e2.value isEqual:@"$42.00"]);
        
        e3 = sectionData_2013.entries[2];
        XCTAssertTrue([e3.title isEqual:@"MAR"]);
        XCTAssertTrue([e3.value isEqual:@"-$11.00"]);
        
        e4 = sectionData_2013.entries[3];
        XCTAssertTrue([e4.title isEqual:@"APR"]);
        XCTAssertTrue([e4.value isEqual:@"$33.00"]);
        
        e5 = sectionData_2013.entries[4];
        XCTAssertTrue([e5.title isEqual:@"MAY"]);
        XCTAssertTrue([e5.value isEqual:@"-$20.50"]);
        
        e6 = sectionData_2013.entries[5];
        XCTAssertTrue([e6.title isEqual:@"JUN"]);
        XCTAssertTrue([e6.value isEqual:@"-$131.00"]);
        
        e7 = sectionData_2013.entries[6];
        XCTAssertTrue([e7.title isEqual:@"JUL"]);
        XCTAssertTrue([e7.value isEqual:@"-$20.50"]);
        
        e8 = sectionData_2013.entries[7];
        XCTAssertTrue([e8.title isEqual:@"AUG"]);
        XCTAssertTrue([e8.value isEqual:@"-$33.50"]);
        
        e9 = sectionData_2013.entries[8];
        XCTAssertTrue([e9.title isEqual:@"SEP"]);
        XCTAssertTrue([e9.value isEqual:@"-$2.50"]);
        
        e10 = sectionData_2013.entries[9];
        XCTAssertTrue([e10.title isEqual:@"OCT"]);
        XCTAssertTrue([e10.value isEqual:@"-$7.80"]);
        
        e11 = sectionData_2013.entries[10];
        XCTAssertTrue([e11.title isEqual:@"NOV"]);
        XCTAssertTrue([e11.value isEqual:@"$33.00"]);
        
        e12 = sectionData_2013.entries[11];
        XCTAssertTrue([e12.title isEqual:@"DEC"]);
        XCTAssertTrue([e12.value isEqual:@"-$10.10"]);
    }];    
}


- (void) testGraphMonthlySurplusCalculations
{
    BSMonthlySummaryGraphLineController * controller = [[BSMonthlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.fetchController];
    
    // Jan 2013
    BSMonthlySummaryGraphLinePresenter *presenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:controller section:@"2013"];
    NSArray <NSNumber*>*monthlyResults = [presenter income];
    NSArray <NSNumber*>* expectation = @[ @0, @132, @4, @50, @0, @0, @0, @0, @0, @0, @33, @0];
    XCTAssert([monthlyResults count] == 12);
    NSUInteger count = 0;
    for (NSNumber *monthlySum in monthlyResults) {
        XCTAssertTrue([monthlySum integerValue] == [expectation[count] integerValue]);
        count++;
    }

    
    // 2012
    presenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:controller section:@"2012"];
    monthlyResults = [presenter income];
    expectation = @[ @0, @0, @21, @(50.5), @0, @0, @37, @(50.5), @0, @0, @(260.5), @(50.5)];
    XCTAssert([monthlyResults count] == 12);
    count = 0;
    for (NSNumber *monthlySum in monthlyResults) {
        XCTAssertTrue([monthlySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    
    // 2011
    presenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:controller section:@"2011"];
    monthlyResults = [presenter income];
    expectation = @[@0, @(220.5), @3, @(50.5), @0, @(32.5), @0, @0, @0, @0, @0, @0];
    XCTAssert([monthlyResults count] == 12);
    count = 0;
    for (NSNumber *monthlySum in monthlyResults) {
        XCTAssertTrue([monthlySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
}


- (void) testGraphMonthlyExpensesCalculations
{
    BSMonthlySummaryGraphLineController * controller = [[BSMonthlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.fetchController];
    
    // Jan 2013
    BSMonthlySummaryGraphLinePresenter *presenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:controller section:@"2013"];
    NSArray <NSNumber*>*monthlyResults = [presenter expenses];
    NSArray <NSNumber*>* expectation = @[@(20), @(90), @(15), @(17), @(20.5), @(131), @(20.5), @(33.5), @(2.5), @(7.8), @0, @(10.1)];
    XCTAssert([monthlyResults count] == 12);
    NSUInteger count = 0;
    for (NSNumber *monthlySum in monthlyResults) {
        XCTAssertTrue([monthlySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    
    // 2012
    presenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:controller section:@"2012"];
    monthlyResults = [presenter expenses];
    expectation = @[ @(20.5), @0, @(12), @0, @0, @0, @(18.5), @0, @(20.5), @0, @0, @0];
    XCTAssert([monthlyResults count] == 12);
    count = 0;
    for (NSNumber *monthlySum in monthlyResults) {
        XCTAssertTrue([monthlySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
    
    
    // 2011
    presenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:controller section:@"2011"];
    monthlyResults = [presenter expenses];
    expectation = @[ @(20.5), @0, @(1), @0, @(20.5), @0, @(5), @0, @0, @0, @0, @(10)];
    XCTAssert([monthlyResults count] == 12);
    count = 0;
    for (NSNumber *monthlySum in monthlyResults) {
        XCTAssertTrue([monthlySum integerValue] == [expectation[count] integerValue]);
        count++;
    }
}

- (void)testCategoryFiltering {
    
    Tag* foodTag;
    Tag* billsTag;
    Tag* travelTag;

    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
    [self.coreDataController createTags:tags];
    foodTag = [self.coreDataController tagForName:@"Food"];
    BSExpenseCategory *foodCategory = [[BSExpenseCategory alloc] initWithName:foodTag.name iconName:foodTag.iconImageName color:foodTag.color];
    billsTag = [self.coreDataController tagForName:@"Bills"];
    travelTag = [self.coreDataController tagForName:@"Travel"];

    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"23/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/10/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
    
    [self.monthlyViewController filterChangedToCategory:foodCategory];
    NSPredicate *predicate_2011 = [NSPredicate predicateWithFormat:@"title = %@", @"2011"];
    NSPredicate *predicate_2012 = [NSPredicate predicateWithFormat:@"title = %@", @"2012"];
    
    [self.monthlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> * _Nonnull sections) {
        
        BSDisplayExpensesSummarySection* _2011 = [sections filteredArrayUsingPredicate:predicate_2011].firstObject;
        BSDisplayExpensesSummarySection* _2012 = [sections filteredArrayUsingPredicate:predicate_2012].firstObject;
        
        XCTAssertTrue([_2011.entries[6].value isEqualToString:@"-$75.00"]);// 6 becuase the month was 7th
        XCTAssertTrue([_2011.entries[11].value isEqualToString:@""]);// 11 becuase the month was 12th
        XCTAssertTrue([_2012.entries[9].value isEqualToString:@"-$5.00"]); //  9 because the day was 10th
    }];
}

- (NSString *)visibleSectionNameMock {
    return self.expectedVisibleSectionName;
}

@end
