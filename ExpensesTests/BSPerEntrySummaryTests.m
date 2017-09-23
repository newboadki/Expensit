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
@end

@implementation BSPerEntrySummaryTests

- (void)setUp
{
    [super setUp];
    
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];    
    
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:self.coreDataStackHelper];
    self.individualEntryViewController = [[BSIndividualExpensesSummaryViewController alloc] init];
    
    
    BSShowAllEntriesController *controller = [[BSShowAllEntriesController alloc] initWithCoreDataStackHelper:self.coreDataStackHelper coreDataController:self.coreDataController];
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
    [self.individualEntryViewController.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        XCTAssertTrue(sections.count == 6);
        
        BSDisplaySectionData *sectionData_19_06_2011 = sections[0];
        XCTAssertTrue(sectionData_19_06_2011.entries.count == 2);
        BSDisplayEntry * e2 = sectionData_19_06_2011.entries[0];
        XCTAssertTrue([e2.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e2.value isEqual:@"$12.00"]);
        BSDisplayEntry * e3 = sectionData_19_06_2011.entries[1];
        XCTAssertTrue([e3.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e3.value isEqual:@"-$5.00"]);

    
        BSDisplaySectionData *sectionData_21_12_2011 = sections[1];
        XCTAssertTrue(sectionData_21_12_2011.entries.count == 1);
        BSDisplayEntry * e1 = sectionData_21_12_2011.entries[0];
        XCTAssertTrue([e1.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e1.value isEqual:@"-$10.00"]);

        
        BSDisplaySectionData *sectionData_02_01_2012 = sections[2];
        XCTAssertTrue(sectionData_02_01_2012.entries.count == 1);
        BSDisplayEntry * e6 = sectionData_02_01_2012.entries[0];
        XCTAssertTrue([e6.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e6.value isEqual:@"-$20.50"]);
        
        BSDisplaySectionData *sectionData_03_03_2012 = sections[3];
        XCTAssertTrue(sectionData_03_03_2012.entries.count == 2);
        BSDisplayEntry * e4 = sectionData_03_03_2012.entries[0];
        XCTAssertTrue([e4.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e4.value isEqual:@"$21.00"]);
        BSDisplayEntry * e5 = sectionData_03_03_2012.entries[1];
        XCTAssertTrue([e5.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e5.value isEqual:@"-$7.00"]);
        
        BSDisplaySectionData *sectionData_13_01_2013 = sections[4];
        XCTAssertTrue(sectionData_13_01_2013.entries.count == 2);
        BSDisplayEntry * e9 = sectionData_13_01_2013.entries[0];
        XCTAssertTrue([e9.title isEqual:@"Food and drinks"]);
        XCTAssertTrue([e9.value isEqual:@"-$20.00"]);
        BSDisplayEntry * e10 = sectionData_13_01_2013.entries[1];
        XCTAssertTrue([e10.title isEqual:@"Salary"]);
        XCTAssertTrue([e10.value isEqual:@"$100.00"]);

        BSDisplaySectionData *sectionData_05_03_2013 = sections[5];
        XCTAssertTrue(sectionData_05_03_2013.entries.count == 2);
        BSDisplayEntry * e7 = sectionData_05_03_2013.entries[0];
        XCTAssertTrue([e7.title isEqual:@"Oyster card"]);
        XCTAssertTrue([e7.value isEqual:@"-$5.00"]);
        BSDisplayEntry * e8 = sectionData_05_03_2013.entries[1];
        XCTAssertTrue([e8.title isEqual:@"Pizza"]);
        XCTAssertTrue([e8.value isEqual:@"-$10.00"]);
    }];
}

@end

@interface BSPerEntrySummaryCategoryFilteringTests : XCTestCase
@property (strong, nonatomic) BSIndividualExpensesSummaryViewController *perEntryViewController;
@end

@implementation BSPerEntrySummaryCategoryFilteringTests

static CoreDataStackHelper *coreDataStackHelper;
static BSCoreDataController *coreDataController;
static Tag* foodTag;
static Tag* billsTag;
static Tag* travelTag;

+ (void)setUp {
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase3"];
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:coreDataStackHelper];
    
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
    
    BSShowAllEntriesController *controller = [[BSShowAllEntriesController alloc] initWithCoreDataStackHelper:coreDataStackHelper coreDataController:coreDataController];
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

    BOOL success = [CoreDataStackHelper destroySQLPersistentStoreCoordinatorWithName:[@"myTestDataBase3" stringByAppendingString:@".sqlite"]];
    [super tearDown];
}

- (void)testOnlyTakeIntoAccountEntriesFromTheFoodCategory {
    [self.perEntryViewController filterChangedToCategory:foodTag];
    NSArray *dailyResults = self.perEntryViewController.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    XCTAssertTrue([dailyResults count] == 3);
    XCTAssertTrue([[dailyResults[0] valueForKey:@"value"] isEqualToNumber:@(-50)]);
    XCTAssertTrue([(id)[dailyResults[0] valueForKey:@"tag"] isEqual:foodTag]);
    
    XCTAssertTrue([[dailyResults[1] valueForKey:@"value"] isEqualToNumber:@(-1000)]);
    XCTAssertTrue([[dailyResults[1] valueForKey:@"tag"] isEqual:foodTag]);
    
    XCTAssertTrue([[dailyResults[2] valueForKey:@"value"] isEqualToNumber:@(-30)]);
    XCTAssertTrue([[dailyResults[2] valueForKey:@"tag"] isEqual:foodTag]);

}

- (void)testOnlyTakeIntoAccountEntriesFromTheTravelCategory {
    [self.perEntryViewController filterChangedToCategory:travelTag];
    NSArray *dailyResults = self.perEntryViewController.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    XCTAssertTrue([dailyResults count] == 2);
    XCTAssertTrue([[dailyResults[0] valueForKey:@"value"] isEqualToNumber:@(-25)]);
    XCTAssertTrue([(id)[dailyResults[0] valueForKey:@"tag"] isEqual:travelTag]);
    
    XCTAssertTrue([[dailyResults[1] valueForKey:@"value"] isEqualToNumber:@(-100)]);
    XCTAssertTrue([[dailyResults[1] valueForKey:@"tag"] isEqual:travelTag]);
}

- (void)testOnlyTakeIntoAccountEntriesFromTheBillsCategory {
    [self.perEntryViewController filterChangedToCategory:billsTag];
    NSArray *dailyResults = self.perEntryViewController.showEntriesPresenter.showEntriesController._fetchedResultsController.fetchedObjects;
    
    XCTAssertTrue([dailyResults count] == 1);
    XCTAssertTrue([[dailyResults[0] valueForKey:@"value"] isEqualToNumber:@(-5.60)]);
    XCTAssertTrue([(id)[dailyResults[0] valueForKey:@"tag"] isEqual:billsTag]);
}

@end
