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
#import "Expensit-Swift.h"

@interface BSPerEntrySummaryTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) BSIndividualExpensesSummaryViewController *individualEntryViewController;
@property (strong, nonatomic) BSCoreDataFetchController *fetchController;
@end

@implementation BSPerEntrySummaryTests

- (void)setUp
{
    [super setUp];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];    
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:self.coreDataStackHelper];
    self.individualEntryViewController = [[BSIndividualExpensesSummaryViewController alloc] init];
    self.fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:self.coreDataController];
    
    BSShowAllEntriesController *controller = [[BSShowAllEntriesController alloc] initWithDataProvider:self.fetchController];
    BSShowAllEntriesPresenter *presenter = [[BSShowAllEntriesPresenter alloc] initWithShowEntriesUserInterface:self.individualEntryViewController showEntriesController:controller];
    self.individualEntryViewController.showEntriesPresenter = presenter;

    NSArray *tags = @[@"Basic"];
    [self.coreDataController createTags:tags];
    Tag *foodTag = [self.coreDataController tagForName:@"Basic"];

    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Food and drinks" value:@"-20.0" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Salary" value:@"100.0" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:foodTag];
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"21.0" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"-7.0" category:foodTag];
    
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"-5" category:foodTag];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:foodTag];
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
    
    NSArray *monthlyResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self.coreDataController fetchRequestForAllEntries] error:nil];
    for (NSManagedObject *obj in monthlyResults)
    {
        [self.coreDataStackHelper.managedObjectContext deleteObject:obj];
        
    }
    [self.coreDataController saveChanges];

    self.coreDataStackHelper = nil;
    self.individualEntryViewController = nil;

    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase" stringByAppendingString:@".sqlite"]];
    [super tearDown];
}

- (void) testIndividualEntriesCalculations
{
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    [self.individualEntryViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        XCTAssertTrue(sections.count == 6);

        BSDisplayExpensesSummarySection *sectionData_21_12_2011 = sections[0];
        XCTAssertTrue(sectionData_21_12_2011.entries.count == 1);
        BSDisplayExpensesSummaryEntry * e1 = sectionData_21_12_2011.entries[0];
        XCTAssertTrue([e1.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e1.value isEqual:@"-$10.00"]);

        BSDisplayExpensesSummarySection *sectionData_19_06_2011 = sections[1];
        XCTAssertTrue(sectionData_19_06_2011.entries.count == 2);
        BSDisplayExpensesSummaryEntry * e2 = sectionData_19_06_2011.entries[0];
        XCTAssertTrue([e2.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e2.value isEqual:@"$12.00"]);
        BSDisplayExpensesSummaryEntry * e3 = sectionData_19_06_2011.entries[1];
        XCTAssertTrue([e3.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e3.value isEqual:@"-$5.00"]);
        
        BSDisplayExpensesSummarySection *sectionData_02_01_2012 = sections[2];
        XCTAssertTrue(sectionData_02_01_2012.entries.count == 1);
        BSDisplayExpensesSummaryEntry * e6 = sectionData_02_01_2012.entries[0];
        XCTAssertTrue([e6.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e6.value isEqual:@"-$20.50"]);
        
        BSDisplayExpensesSummarySection *sectionData_03_03_2012 = sections[3];
        XCTAssertTrue(sectionData_03_03_2012.entries.count == 2);
        BSDisplayExpensesSummaryEntry * e4 = sectionData_03_03_2012.entries[0];
        XCTAssertTrue([e4.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e4.value isEqual:@"$21.00"]);
        BSDisplayExpensesSummaryEntry * e5 = sectionData_03_03_2012.entries[1];
        XCTAssertTrue([e5.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e5.value isEqual:@"-$7.00"]);
        
        BSDisplayExpensesSummarySection *sectionData_13_01_2013 = sections[4];
        XCTAssertTrue(sectionData_13_01_2013.entries.count == 2);
        BSDisplayExpensesSummaryEntry * e9 = sectionData_13_01_2013.entries[0];
        XCTAssertTrue([e9.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e9.value isEqual:@"-$20.00"]);
        BSDisplayExpensesSummaryEntry * e10 = sectionData_13_01_2013.entries[1];
        XCTAssertTrue([e10.title isEqual:@"Salary"]);
        XCTAssertTrue([e10.value isEqual:@"$100.00"]);

        BSDisplayExpensesSummarySection *sectionData_05_03_2013 = sections[5];
        XCTAssertTrue(sectionData_05_03_2013.entries.count == 2);
        BSDisplayExpensesSummaryEntry * e7 = sectionData_05_03_2013.entries[0];
        XCTAssertTrue([e7.title isEqual:@"Oyster card"]);
        XCTAssertTrue([e7.value isEqual:@"-$5.00"]);
        BSDisplayExpensesSummaryEntry * e8 = sectionData_05_03_2013.entries[1];
        XCTAssertTrue([e8.title isEqual:@"Pizza"]);
        XCTAssertTrue([e8.value isEqual:@"-$10.00"]);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

@end

@interface BSPerEntrySummaryCategoryFilteringTests : XCTestCase
@property (strong, nonatomic) BSIndividualExpensesSummaryViewController *perEntryViewController;
@end

@implementation BSPerEntrySummaryCategoryFilteringTests

static CoreDataStackHelper *coreDataStackHelper;
static BSCoreDataController *coreDataController;
static BSCoreDataFetchController *fetchController;
static Tag* foodTag;
static Tag* billsTag;
static Tag* travelTag;

+ (void)setUp {
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase3"];
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:coreDataStackHelper];
    fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:coreDataController];
    
    NSArray *tags = @[@"Food", @"Bills", @"Travel"];
    [coreDataController createTags:tags];
    foodTag = [coreDataController tagForName:@"Food"];
    billsTag = [coreDataController tagForName:@"Bills"];
    travelTag =[coreDataController tagForName:@"Travel"];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Fish and Chips" value:@"-1000" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Gasoline" value:@"-25" category:travelTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Dinner" value:@"-30" category:foodTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Food and drinks" value:@"-5.60" category:billsTag];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Trip" value:@"-100" category:travelTag];
}

- (void)setUp
{
    self.perEntryViewController = [[BSIndividualExpensesSummaryViewController alloc] init];
    
    BSShowAllEntriesController *controller = [[BSShowAllEntriesController alloc] initWithDataProvider:fetchController];
    BSShowAllEntriesPresenter *presenter = [[BSShowAllEntriesPresenter alloc] initWithShowEntriesUserInterface:self.perEntryViewController showEntriesController:controller];
    self.perEntryViewController.showEntriesPresenter = presenter;
    

    
    self.perEntryViewController.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];
    
    UINavigationItem *navItemMock = [UINavigationItem new];
    navItemMock.rightBarButtonItems = @[[UIBarButtonItem new], [UIBarButtonItem new]];
    [self.perEntryViewController setValue:navItemMock forKey:@"navigationItem"];


    [super setUp];
}

+ (void)tearDown {
    NSArray *monthlyResults = [coreDataStackHelper.managedObjectContext executeFetchRequest:[coreDataController fetchRequestForAllEntries] error:nil];
    for (NSManagedObject *obj in monthlyResults)
    {
        [coreDataStackHelper.managedObjectContext deleteObject:obj];
        
    }
    [coreDataController saveChanges];

    [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase3" stringByAppendingString:@".sqlite"]];
    [super tearDown];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheFoodCategory {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    BSExpenseCategory *foodCategory = [[BSExpenseCategory alloc] initWithName:foodTag.name iconName:foodTag.iconImageName color:foodTag.color];
    [self.perEntryViewController filterChangedToCategory:foodCategory];
    
    [self.perEntryViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> * _Nonnull sections) {
        XCTAssertTrue(sections.count == 2);
        
        BSDisplayExpensesSummarySection *jul_19_2011 = sections.firstObject;
        XCTAssertTrue(jul_19_2011.entries.count == 2);
        XCTAssertTrue([jul_19_2011.entries.firstObject.value isEqualToString:@"-$50.00"]);
        XCTAssertTrue([jul_19_2011.entries.firstObject.tag isEqualToString:@"Food"]);
        XCTAssertTrue([jul_19_2011.entries.firstObject.desc isEqualToString:@"Food and drinks"]);
        XCTAssertTrue([jul_19_2011.entries.lastObject.value isEqualToString:@"-$1,000.00"]);
        XCTAssertTrue([jul_19_2011.entries.lastObject.tag isEqualToString:@"Food"]);
        XCTAssertTrue([jul_19_2011.entries.lastObject.desc isEqualToString:@"Fish and Chips"]);
        
        BSDisplayExpensesSummarySection *jul_19_2012 = sections.lastObject;
        XCTAssertTrue(jul_19_2012.entries.count == 1);
        XCTAssertTrue([jul_19_2012.entries.firstObject.value isEqualToString:@"-$30.00"]);
        XCTAssertTrue([jul_19_2012.entries.firstObject.tag isEqualToString:@"Food"]);
        XCTAssertTrue([jul_19_2012.entries.firstObject.desc isEqualToString:@"Dinner"]);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheTravelCategory {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    BSExpenseCategory *travelCategory = [[BSExpenseCategory alloc] initWithName:travelTag.name iconName:travelTag.iconImageName color:travelTag.color];
    [self.perEntryViewController filterChangedToCategory:travelCategory];

    [self.perEntryViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> * _Nonnull sections) {
        XCTAssertTrue(sections.count == 2);
        
        BSDisplayExpensesSummarySection *jul_19_2011 = sections.firstObject;
        XCTAssertTrue([jul_19_2011.entries.firstObject.value isEqualToString:@"-$25.00"]);
        XCTAssertTrue(jul_19_2011.entries.count == 1);

        BSDisplayExpensesSummarySection *oct_2_2013 = sections.lastObject;
        XCTAssertTrue([oct_2_2013.entries.firstObject.value isEqualToString:@"-$100.00"]);
        XCTAssertTrue(oct_2_2013.entries.count == 1);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheBillsCategory {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@""];
    
    BSExpenseCategory *billsCategory = [[BSExpenseCategory alloc] initWithName:billsTag.name iconName:billsTag.iconImageName color:billsTag.color];
    [self.perEntryViewController filterChangedToCategory:billsCategory];
    
    [self.perEntryViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^(NSArray<BSDisplayExpensesSummarySection *> * _Nonnull sections) {        
        XCTAssertTrue([sections.firstObject.entries.firstObject.value isEqualToString:@"-$5.60"]);
        XCTAssertTrue(sections.firstObject.entries.count == 1);
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

@end
