//
//  BSBSExpenseDeletionTests.m
//  ExpensesTests
//
//  Created by Borja Arias Drake on 21/10/2018.
//  Copyright © 2018 Borja Arias Drake. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Expensit-Swift.h"
#import "Tag.h"


@interface BSBSExpenseDeletionTests : XCTestCase
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (strong, nonatomic) NSString *expectedVisibleSectionName;
@property (strong, nonatomic) BSAddEntryController *controller;
@property (strong, nonatomic) BSCoreDataFetchController *fetchController;
@end

@implementation BSBSExpenseDeletionTests

- (void)setUp
{
    [CoreDataStackHelper destroyAllExtensionsForSQLPersistentStoreCoordinatorWithName:@"myTestDataBase"];
    self.coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                          resourceName:@"Expenses"
                                                                             extension:@"momd"
                                                                   persistentStoreName:@"myTestDataBase"];
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" coreDataHelper:self.coreDataStackHelper];
    self.fetchController = [[BSCoreDataFetchController alloc] initWithCoreDataController:self.coreDataController];
    self.controller = [[BSAddEntryController alloc] initWithEntryToEdit:nil coreDataFetchController:self.fetchController];
}

- (void)tearDown
{
    [CoreDataStackHelper destroyAllExtensionsForSQLPersistentStoreCoordinatorWithName:@"myTestDataBase"];
    self.coreDataStackHelper = nil;
    [super tearDown];
}


/**
 This tests the interaction between the deletion controller and the underlying data source.
 */
- (void)testExpenseDeletion {

    // Create an expense
    NSArray *tags = @[@"Food"];
    [self.coreDataController createTags:tags];
    Tag *foodTag = [self.coreDataController tagForName:@"Food"];
    [self.coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:foodTag];
    
    // Check there's one expense
    ExpensesGroup *group = [self.fetchController allEntries].firstObject;
    Expense *expense = group.entries.firstObject;
    XCTAssertNotNil(expense);
    
    // Delete the expense
    [self.controller deleteWithEntry:expense];
    
    // Check there's no expenses
    NSArray <ExpensesGroup *>*groups = [self.fetchController allEntries];
    XCTAssertTrue(groups.count == 0);
}

@end
