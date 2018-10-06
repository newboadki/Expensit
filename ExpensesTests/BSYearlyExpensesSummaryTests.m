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
#import "Expensit-Swift.h"



static CoreDataStackHelper *coreDataStackHelper;
static BSCoreDataController *coreDataController;
static BSYearlyExpensesSummaryViewController *yearlyViewController;
static BSShowYearlyEntriesController *controller;
static BSShowYearlyEntriesPresenter *presenter;
static BSCoreDataFetchController *fetchController;


@interface BSYearlyExpensesSummaryTests : XCTestCase
@end

@implementation BSYearlyExpensesSummaryTests

- (void)setUp
{
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-shm"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-wal"]];


    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"BSYESummaryTestsDataBase"];
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:coreDataStackHelper];
    fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:coreDataController];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    yearlyViewController = [storyboard instantiateViewControllerWithIdentifier:@"BSYearlyExpensesSummaryViewController"];

    
    yearlyViewController.collectionView = nil;
    yearlyViewController.collectionView = nil;

    controller = [[BSShowYearlyEntriesController alloc] initWithDataProvider:fetchController];
    presenter = [[BSShowYearlyEntriesPresenter alloc] initWithShowEntriesUserInterface:yearlyViewController
                                                                                         showEntriesController:controller];
    yearlyViewController.showEntriesPresenter = presenter;

    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"1" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"2" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-1" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:nil];
}

- (void)tearDown
{
    coreDataStackHelper = nil;
    yearlyViewController = nil;
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-shm"]];
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"BSYESummaryTestsDataBase" stringByAppendingString:@".sqlite-wal"]];

    [super tearDown];
}

#pragma mark - Tests

- (void) test_yearly_calculations_With_no_filter
{
    [yearlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray <BSDisplayExpensesSummarySection *>* _Nullable sections) {
        
        XCTAssertTrue(sections.count == 3);

        BSDisplayExpensesSummarySection *_2013 = sections[0];
        XCTAssertTrue(_2013.entries.count == 1);
        XCTAssertTrue([_2013.entries.firstObject.value isEqualToString:@"-$6.90"]);
        XCTAssertTrue([_2013.entries.firstObject.title isEqualToString:@"2013"]);
        
        BSDisplayExpensesSummarySection *_2012 = sections[1];
        XCTAssertTrue(_2012.entries.count == 1);
        XCTAssertTrue([_2012.entries.firstObject.value isEqualToString:@"$398.50"]);
        XCTAssertTrue([_2012.entries.firstObject.title isEqualToString:@"2012"]);
        
        BSDisplayExpensesSummarySection *_2011 = sections[2];
        XCTAssertTrue(_2011.entries.count == 1);
        XCTAssertTrue([_2011.entries.firstObject.value isEqualToString:@"$249.50"]);
        XCTAssertTrue([_2011.entries.firstObject.title isEqualToString:@"2011"]);

        
        
        
//        XCTAssertTrue(sections.count == 1);
//        BSDisplayExpensesSummarySection *sectionData = sections.firstObject;
//        XCTAssertTrue(sectionData.entries.count == 3);
//
//        BSDisplayExpensesSummaryEntry * e1 = sectionData.entries[0];
//        BSDisplayExpensesSummaryEntry * e2 = sectionData.entries[1];
//        BSDisplayExpensesSummaryEntry * e3 = sectionData.entries[2];
//
//        XCTAssertTrue([e1.title isEqual:@"2013"]);
//        XCTAssertTrue([e1.value isEqual:@"-$6.90"]);
//        XCTAssertTrue([e2.title isEqual:@"2012"]);
//        XCTAssertTrue([e2.value isEqual:@"$398.50"]);
//        XCTAssertTrue([e3.title isEqual:@"2011"]);
//        XCTAssertTrue([e3.value isEqual:@"$249.50"]);
    }];
}

- (void) test_yearly_calculations_With_filter
{
    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
    [coreDataController createTags:tags];
    Tag* foodTag = [coreDataController tagForName:@"Food"];
    Tag* billsTag = [coreDataController tagForName:@"Bills"];
    Tag* travelTag = [coreDataController tagForName:@"Travel"];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
    
    BSExpenseCategory *foodCategory = [[BSExpenseCategory alloc] initWithName:foodTag.name iconName:foodTag.iconImageName color:foodTag.color];
    [yearlyViewController filterChangedToCategory:foodCategory];
    
    // This preenter is not the same instance that is created at the top of the file
    [yearlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        XCTAssertTrue(sections.count == 2);
        
        BSDisplayExpensesSummarySection *_2012 = sections.firstObject;
        XCTAssertTrue(_2012.entries.count == 1);
        XCTAssertTrue([_2012.entries.firstObject.value isEqualToString:@"-$5.00"]);
        XCTAssertTrue([_2012.entries.firstObject.title isEqualToString:@"2012"]);
        
        BSDisplayExpensesSummarySection *_2011 = sections.lastObject;
        XCTAssertTrue(_2011.entries.count == 1);
        XCTAssertTrue([_2011.entries.firstObject.value isEqualToString:@"-$75.00"]);
        XCTAssertTrue([_2011.entries.firstObject.title isEqualToString:@"2011"]);
    }];
}

- (void) testGraphYearlySurplusCalculations
{
    
    BSYearlySummaryGraphLineController *controller = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataFetchController:fetchController];
    
    BSYearlySummaryGraphLinePresenter *presenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:controller section:@"2011"];
    
    NSArray <NSNumber*>*yearlyResults = [presenter income];
    NSArray <NSString*>*abscissaValues = [presenter abscissaValues];
    
    
    NSArray <NSNumber*>* surplusExpectation = @[@(306.5), @(470), @(254)];
    NSArray <NSNumber*>* abscissaValuesExpectation = @[@"2011", @"2012", @"2013"];
    XCTAssert([surplusExpectation count] == 3);
    XCTAssert([abscissaValuesExpectation count] == 3);
    NSUInteger count = 0;
    for (NSNumber *yearlySum in yearlyResults) {
        XCTAssertTrue([yearlySum integerValue] == [surplusExpectation[count] integerValue]);
        XCTAssertTrue([abscissaValues[count] isEqual:abscissaValuesExpectation[count]]);
        count++;
    }
}


- (void) testGraphYearlyExpensesCalculations
{
    BSYearlySummaryGraphLineController *controller = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataFetchController:fetchController];
    
    BSYearlySummaryGraphLinePresenter *presenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:controller section:@"2011"];
    
    NSArray <NSNumber*>*yearlyResults = [presenter expenses];
    NSArray <NSString*>*abscissaValues = [presenter abscissaValues];
    
    
    NSArray <NSNumber*>* surplusExpectation = @[@(57), @(71.5), @(260.9)];
    NSArray <NSNumber*>* abscissaValuesExpectation = @[@"2011", @"2012", @"2013"];
    XCTAssert([surplusExpectation count] == 3);
    XCTAssert([abscissaValuesExpectation count] == 3);
    NSUInteger count = 0;
    for (NSNumber *yearlySum in yearlyResults) {
        XCTAssertTrue([yearlySum integerValue] == [surplusExpectation[count] integerValue]);
        XCTAssertTrue([abscissaValues[count] isEqual:abscissaValuesExpectation[count]]);
        count++;
    }
}

@end


@interface BSYearlyExpensesSummaryCategoryFilteringTests : XCTestCase
@end

@implementation BSYearlyExpensesSummaryCategoryFilteringTests

static Tag* foodTag;
static Tag* billsTag;
static Tag* travelTag;


- (void)setUp
{
    [super setUp];

    [CoreDataStackHelper destroyAllExtensionsForSQLPersistentStoreCoordinatorWithName:@"BSYESummaryTestsDataBase"];
    
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                     resourceName:@"Expenses"
                                                                        extension:@"momd"
                                                              persistentStoreName:@"BSYESummaryTestsDataBase"];
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:coreDataStackHelper];
    fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:coreDataController];

    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
    [coreDataController createTags:tags];
    foodTag = [coreDataController tagForName:@"Food"];
    foodTag.iconImageName = @"";
    foodTag.color = UIColor.blueColor;
    billsTag = [coreDataController tagForName:@"Bills"];
    travelTag = [coreDataController tagForName:@"Travel"];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    yearlyViewController = [storyboard instantiateViewControllerWithIdentifier:@"BSYearlyExpensesSummaryViewController"];
    
    
    yearlyViewController.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];
    
    UINavigationItem *navItemMock = [UINavigationItem new];
    navItemMock.rightBarButtonItems = @[[UIBarButtonItem new], [UIBarButtonItem new]];
    [yearlyViewController setValue:navItemMock forKey:@"navigationItem"];

    
    controller = [[BSShowYearlyEntriesController alloc] initWithDataProvider:fetchController];
    presenter = [[BSShowYearlyEntriesPresenter alloc] initWithShowEntriesUserInterface:yearlyViewController
                                                                 showEntriesController:controller];
    yearlyViewController.showEntriesPresenter = presenter;
}

- (void)tearDown
{
    [CoreDataStackHelper destroyAllExtensionsForSQLPersistentStoreCoordinatorWithName:@"BSYESummaryTestsDataBase"];
    coreDataStackHelper = nil;
    yearlyViewController = nil;
    [super tearDown];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheSpecifiedCategory {
    BSExpenseCategory *foodCategory = [[BSExpenseCategory alloc] initWithName:foodTag.name iconName:foodTag.iconImageName color:foodTag.color];
    [yearlyViewController filterChangedToCategory:foodCategory];

    [yearlyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> * _Nonnull sections) {
        XCTAssertTrue(sections.count == 2);
        
        BSDisplayExpensesSummarySection *_2012 = sections.firstObject;
        XCTAssertTrue(_2012.entries.count == 1);
        XCTAssertTrue([_2012.entries.firstObject.value isEqualToString:@"-$5.00"]);
        XCTAssertTrue([_2012.entries.firstObject.title isEqualToString:@"2012"]);
        
        BSDisplayExpensesSummarySection *_2011 = sections.lastObject;
        XCTAssertTrue(_2011.entries.count == 1);
        XCTAssertTrue([_2011.entries.firstObject.value isEqualToString:@"-$75.00"]);
        XCTAssertTrue([_2011.entries.firstObject.title isEqualToString:@"2011"]);
    }];
}

@end

