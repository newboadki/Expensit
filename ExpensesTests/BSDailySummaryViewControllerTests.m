//
//  BSDailySummaryViewControllerTests.m
//  ExpensesTests
//
//  Created by Borja Arias Drake on 21/09/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSDailyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Expensit-Swift.h"
#import "DailyTestHelper.h"
#import "Tag.h"


@interface BSDailyExpensesSummaryViewController ()
- (NSArray *)graphSurplusResults;
- (NSArray *)graphExpensesResults;
@end

@interface BSDailySummaryViewControllerTests : XCTestCase
@end

@implementation BSDailySummaryViewControllerTests

static CoreDataStackHelper *coreDataStackHelper = nil;
static BSCoreDataController *coreDataController = nil;
static BSDailyExpensesSummaryViewController *dailyViewController = nil;
static BSCoreDataFetchController *fetchController;

+ (void)setUp {
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase" stringByAppendingString:@".sqlite"]];
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:coreDataStackHelper];
    fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:coreDataController];
    dailyViewController = [[BSDailyExpensesSummaryViewController alloc] init];
    dailyViewController.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];
    
    BSShowDailyEntriesController *controller = [[BSShowDailyEntriesController alloc] initWithDataProvider:fetchController];
    BSShowDailyEntriesPresenter *presenter = [[BSShowDailyEntriesPresenter alloc] initWithShowEntriesUserInterface:dailyViewController showEntriesController:controller];
    dailyViewController.showEntriesPresenter = presenter;
    
    NSArray *tags = @[@"Basic"];
    [coreDataController createTags:tags];
    Tag *foodTag = [coreDataController tagForName:@"Basic"];
    
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Food and drinks" value:@"-20.0" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Salary" value:@"100.0" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:foodTag];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"21.0" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"-7.0" category:foodTag];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"-5" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:foodTag];
}

+ (void)tearDown {
    
    NSArray *monthlyResults = [coreDataStackHelper.managedObjectContext executeFetchRequest:[coreDataController fetchRequestForAllEntries] error:nil];
    for (NSManagedObject *obj in monthlyResults)
    {
        [coreDataStackHelper.managedObjectContext deleteObject:obj];

    }
    [coreDataController saveChanges];

    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase" stringByAppendingString:@".sqlite"]];
    [super tearDown];
}


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testDailyCalculations {
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    UINavigationItem *navItemMock = [UINavigationItem new];
    navItemMock.rightBarButtonItems = @[[UIBarButtonItem new], [UIBarButtonItem new]];
    [dailyViewController setValue:navItemMock forKey:@"navigationItem"];
    
    [dailyViewController filterChangedToCategory:nil];
    
    NSPredicate *predicate_Jan_2013 = [NSPredicate predicateWithFormat:@"title = %@", @"1/2013"];
    NSPredicate *predicate_Mar_2013 = [NSPredicate predicateWithFormat:@"title = %@", @"3/2013"];
    NSPredicate *predicate_Jan_2012 = [NSPredicate predicateWithFormat:@"title = %@", @"1/2012"];
    NSPredicate *predicate_Mar_2012 = [NSPredicate predicateWithFormat:@"title = %@", @"3/2012"];
    NSPredicate *predicate_Jun_2011 = [NSPredicate predicateWithFormat:@"title = %@", @"6/2011"];
    NSPredicate *predicate_Dec_2011 = [NSPredicate predicateWithFormat:@"title = %@", @"12/2011"];
    
    [dailyViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> *sections) {
        
        BSDisplayExpensesSummarySection* jan2013 = [sections filteredArrayUsingPredicate:predicate_Jan_2013].firstObject;
        BSDisplayExpensesSummarySection* march2013 = [sections filteredArrayUsingPredicate:predicate_Mar_2013].firstObject;
        BSDisplayExpensesSummarySection* jan2012 = [sections filteredArrayUsingPredicate:predicate_Jan_2012].firstObject;
        BSDisplayExpensesSummarySection* march2012 = [sections filteredArrayUsingPredicate:predicate_Mar_2012].firstObject;
        BSDisplayExpensesSummarySection* jun2011 = [sections filteredArrayUsingPredicate:predicate_Jun_2011].firstObject;
        BSDisplayExpensesSummarySection* dec2011 = [sections filteredArrayUsingPredicate:predicate_Dec_2011].firstObject;
        
        XCTAssertTrue([jan2013.entries[12].value isEqualToString:@"$80.00"]);// 12 becuase the day was 13th
        XCTAssertTrue([march2013.entries[4].value isEqualToString:@"-$15.00"]); // 4 because the day was 5th
        XCTAssertTrue([jan2012.entries[1].value isEqualToString:@"-$20.50"]); // 4 because the day was 5th
        XCTAssertTrue([march2012.entries[2].value isEqualToString:@"$14.00"]); // 2 because the day was 3rd
        XCTAssertTrue([jun2011.entries[18].value isEqualToString:@"$7.00"]); // 18 because the day was 19th
        XCTAssertTrue([dec2011.entries[20].value isEqualToString:@"-$10.00"]); // 20 because the day was 21st
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

@end


@interface BSDailySummaryViewControllerCategoryFilteringTests : XCTestCase
@end

@implementation BSDailySummaryViewControllerCategoryFilteringTests

static CoreDataStackHelper *cdsh = nil;
static BSCoreDataController *cdc = nil;
static BSDailyExpensesSummaryViewController *dvc = nil;
static Tag* foodTag;
static Tag* billsTag;
static Tag* travelTag;
static ExpenseCategory* foodCategory;
static ExpenseCategory* billsCategory;
static ExpenseCategory* travelCategory;

static BSCoreDataFetchController *fetchController;

+ (void)setUp {
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase2" stringByAppendingString:@".sqlite"]];
    cdsh = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase2"];
    
    cdc = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:cdsh];
    fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:cdc];
    dvc = [[BSDailyExpensesSummaryViewController alloc] init];
    dvc.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];

    BSShowDailyEntriesController *controller = [[BSShowDailyEntriesController alloc] initWithDataProvider:fetchController];
    BSShowDailyEntriesPresenter *presenter = [[BSShowDailyEntriesPresenter alloc] initWithShowEntriesUserInterface:dvc showEntriesController:controller];
    dvc.showEntriesPresenter = presenter;
    
    UINavigationItem *navItemMock = [UINavigationItem new];
    navItemMock.rightBarButtonItems = @[[UIBarButtonItem new], [UIBarButtonItem new]];
    [dvc setValue:navItemMock forKey:@"navigationItem"];


    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
    [cdc createTags:tags];
    foodTag = [cdc tagForName:@"Food"];
    billsTag = [cdc tagForName:@"Bills"];
    travelTag = [cdc tagForName:@"Travel"];
    foodCategory = [[ExpenseCategory alloc] initWithName:foodTag.name iconName:foodTag.iconImageName color:foodTag.color];
    travelCategory = [[ExpenseCategory alloc] initWithName:travelTag.name iconName:travelTag.iconImageName color:travelTag.color];
    billsCategory = [[ExpenseCategory alloc] initWithName:billsTag.name iconName:billsTag.iconImageName color:billsTag.color];
    
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Fish and Chips" value:@"-1000" category:foodTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Gasoline" value:@"-25" category:travelTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Dinner" value:@"-30" category:foodTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Electricity" value:@"-5.60" category:billsTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Trip" value:@"-100" category:travelTag];
}

+ (void)tearDown {
    
    NSArray *monthlyResults = [cdsh.managedObjectContext executeFetchRequest:[cdc fetchRequestForAllEntries] error:nil];
    for (NSManagedObject *obj in monthlyResults)
    {
        [cdsh.managedObjectContext deleteObject:obj];

    }
    [cdc saveChanges];

    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase2" stringByAppendingString:@".sqlite"]];
    [super tearDown];
}

- (void)setUp {
    [super setUp];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheFoodCategory {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    [dvc filterChangedToCategory:foodCategory];

    NSPredicate *predicate_July_2011 = [NSPredicate predicateWithFormat:@"title = %@", [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
    NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"date = %@", [NSString stringWithFormat:@"19/07/2011"]];
    NSPredicate *predicate_July_2012 = [NSPredicate predicateWithFormat:@"title = %@", [NSString stringWithFormat:@"%@/%@", @(7), @(2012)]];
    NSPredicate *predicate_19_July_2012 = [NSPredicate predicateWithFormat:@"date = %@", [NSString stringWithFormat:@"19/07/2012"]];

    [dvc.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> *sections) {
        
        BSDisplayExpensesSummarySection* july2011 = [sections filteredArrayUsingPredicate:predicate_July_2011].firstObject;
        BSDisplayExpensesSummarySection* july2012 = [sections filteredArrayUsingPredicate:predicate_July_2012].firstObject;
        BSDisplayExpensesSummaryEntry *july_19_2011 = [july2011.entries filteredArrayUsingPredicate:predicate_19_July_2011].firstObject;
        BSDisplayExpensesSummaryEntry *july_19_2012 = [july2012.entries filteredArrayUsingPredicate:predicate_19_July_2012].firstObject;
        
        XCTAssertTrue([july_19_2011.value isEqualToString:@"-$1,050.00"]);
        XCTAssertTrue([july_19_2012.value isEqualToString:@"-$30.00"]);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheTravelCategory {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    [dvc filterChangedToCategory:travelCategory];
    
    NSPredicate *predicate_July_2011 = [NSPredicate predicateWithFormat:@"title = %@", [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
    NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"date = %@", [NSString stringWithFormat:@"19/07/2011"]];
    NSPredicate *predicate_Oct_2013 = [NSPredicate predicateWithFormat:@"title = %@", [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
    NSPredicate *predicate_02_Oct_2013 = [NSPredicate predicateWithFormat:@"date = %@", [NSString stringWithFormat:@"02/10/2013"]];

    [dvc.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> *sections) {
        BSDisplayExpensesSummarySection* july2011 = [sections filteredArrayUsingPredicate:predicate_July_2011].firstObject;
        BSDisplayExpensesSummarySection* october2012 = [sections filteredArrayUsingPredicate:predicate_Oct_2013].firstObject;
        BSDisplayExpensesSummaryEntry *july_19_2011 = [july2011.entries filteredArrayUsingPredicate:predicate_19_July_2011].firstObject;
        BSDisplayExpensesSummaryEntry *october_02_2013 = [october2012.entries filteredArrayUsingPredicate:predicate_02_Oct_2013].firstObject;

        XCTAssertTrue([july_19_2011.title isEqualToString:@"19"]);
        XCTAssertTrue([july_19_2011.value isEqualToString:@"-$25.00"]);        
        XCTAssertTrue([october_02_2013.title isEqualToString:@"2"]);
        XCTAssertTrue([october_02_2013.value isEqualToString:@"-$100.00"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheBillsCategory {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    [dvc filterChangedToCategory:billsCategory];
    
    [dvc.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> *sections) {
        XCTAssertTrue(sections.count == 1);
        BSDisplayExpensesSummarySection *results_02_Oct_2013 = sections.firstObject;
        NSPredicate *predicate_02_Oct_2013 = [NSPredicate predicateWithFormat:@"date = %@", @"02/10/2013"];
        BSDisplayExpensesSummaryEntry *e_02_Oct_2013 =  [[results_02_Oct_2013.entries filteredArrayUsingPredicate:predicate_02_Oct_2013] lastObject];
        XCTAssertTrue([e_02_Oct_2013.title isEqual:@"2"]);
        XCTAssertTrue([e_02_Oct_2013.value isEqual:@"-$5.60"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:10];
}
@end
