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
#import "Tag.h"
#import "Expensit-Swift.h"
#import "DailyTestHelper.h"


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

+ (void)setUp {
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase" stringByAppendingString:@".sqlite"]];
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:coreDataStackHelper];
    dailyViewController = [[BSDailyExpensesSummaryViewController alloc] init];
    dailyViewController.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];
    
    
    
    
    BSShowDailyEntriesController *controller = [[BSShowDailyEntriesController alloc] initWithCoreDataStackHelper:coreDataStackHelper
                                                                                              coreDataController:coreDataController];
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
    
    UINavigationItem *navItemMock = [UINavigationItem new];
    navItemMock.rightBarButtonItems = @[[UIBarButtonItem new], [UIBarButtonItem new]];
    [dailyViewController setValue:navItemMock forKey:@"navigationItem"];
    
    
    [dailyViewController filterChangedToCategory:nil];
    NSArray *dailyResults = dailyViewController.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    XCTAssertTrue([dailyResults count] == 6);
    XCTAssertTrue([[[DailyTestHelper resultDictionaryForDate:@"13/01/2013" fromArray:dailyResults] valueForKey:@"dailySum"] isEqual:@80]);
    XCTAssertTrue([[[DailyTestHelper resultDictionaryForDate:@"05/03/2013" fromArray:dailyResults] valueForKey:@"dailySum"] isEqual:@(-15)]);
    XCTAssertTrue([[[DailyTestHelper resultDictionaryForDate:@"02/01/2012" fromArray:dailyResults] valueForKey:@"dailySum"] isEqual:@(-20.5)]);
    XCTAssertTrue([[[DailyTestHelper resultDictionaryForDate:@"03/03/2012" fromArray:dailyResults] valueForKey:@"dailySum"] isEqual:@(14)]);
    XCTAssertTrue([[[DailyTestHelper resultDictionaryForDate:@"19/06/2011" fromArray:dailyResults] valueForKey:@"dailySum"] isEqual:@7]);
    XCTAssertTrue([[[DailyTestHelper resultDictionaryForDate:@"21/12/2011" fromArray:dailyResults] valueForKey:@"dailySum"] isEqual:@(-10)]);
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

+ (void)setUp {
    [super setUp];
    
    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase2" stringByAppendingString:@".sqlite"]];
    cdsh = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase2"];
    
    cdc = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:cdsh];
    dvc = [[BSDailyExpensesSummaryViewController alloc] init];
    dvc.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];

    BSShowDailyEntriesController *controller = [[BSShowDailyEntriesController alloc] initWithCoreDataStackHelper:cdsh coreDataController:cdc];
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
    
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Fish and Chips" value:@"-1000" category:foodTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Gasoline" value:@"-25" category:travelTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Dinner" value:@"-30" category:foodTag];
    [cdc insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Food and drinks" value:@"-5.60" category:billsTag];
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
    [dvc filterChangedToCategory:foodTag];
    NSArray *dailyResults = dvc.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
    NSPredicate *predicate_19_July_2012 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2012)]];
    NSArray *results_19_July_2011 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2011] lastObject];
    NSArray *results_19_July_2012 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2012] lastObject];
    
    XCTAssertTrue([dailyResults count] == 2);
    XCTAssertTrue([[results_19_July_2011 valueForKey:@"dailySum"] isEqual:@(-1050)]);
    XCTAssertTrue([[results_19_July_2012 valueForKey:@"dailySum"] isEqual:@(-30)]);
}

- (void)testOnlyTakeIntoAccountEntriesFromTheTravelCategory {
    [dvc filterChangedToCategory:travelTag];
    NSArray *dailyResults = dvc.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
    NSPredicate *predicate_02_Oct_2012 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(2),  [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
    NSArray *results_19_July_2011 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2011] lastObject];
    NSArray *results_02_Oct_2012 =  [[dailyResults filteredArrayUsingPredicate:predicate_02_Oct_2012] lastObject];
        
    XCTAssertTrue([dailyResults count] == 2);
    XCTAssertTrue([[results_19_July_2011 valueForKey:@"dailySum"] isEqual:@(-25)]);
    XCTAssertTrue([[results_02_Oct_2012 valueForKey:@"dailySum"] isEqual:@(-100)]);
}

- (void)testOnlyTakeIntoAccountEntriesFromTheBillsCategory {
    [dvc filterChangedToCategory:billsTag];
    NSArray *dailyResults = dvc.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    NSPredicate *predicate_02_Oct_2013 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(2),  [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
    NSArray *results_02_Oct_2013 =  [[dailyResults filteredArrayUsingPredicate:predicate_02_Oct_2013] lastObject];
    
    XCTAssertTrue([dailyResults count] == 1);
    XCTAssertTrue([[results_02_Oct_2013 valueForKey:@"dailySum"] isEqual:@(-5.60)]);
}
@end
