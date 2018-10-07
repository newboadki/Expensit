//
//  BSCoreDataController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpenseSummaryDataGatewayProtocol.h"

@class Tag;
@class Entry;
@class CoreDataStackHelper;
@class BSExpenseCategory;
@class BSPieChartSectionInfo;


@interface BSCoreDataController : NSObject <NSFetchedResultsControllerDelegate, ExpenseSummaryDataGatewayProtocol>

@property (strong, nonatomic, nonnull) CoreDataStackHelper *coreDataHelper;

- (nonnull instancetype)initWithEntityName:(nonnull NSString *)entityName coreDataHelper:(nonnull CoreDataStackHelper *)coreDataHelper;
- (void)insertNewEntryWithDate:(nonnull NSDate *)date description:(nullable NSString *)description value:(nonnull NSString *)value category:(nullable Tag *)tag;
- (nonnull Entry *)newEntry;
- (void)discardChanges;
- (BOOL)saveChanges;
- (BOOL)saveEntry:(nonnull Entry *)entry error:(NSError * _Nullable * _Nullable)error;
- (void)deleteModel:(nonnull id)model;
- (BOOL)createTags:(nonnull NSArray *)tags;
- (BOOL)setTagForAllEntriesTo:(nonnull NSString *)tag;
- (BOOL)setOtherTagForAllEntriesWithoutTag;
- (BOOL)setIsAmountNegativeFromSignOfAmount;


#pragma mark - Utility requests
- (nonnull NSFetchRequest *)fetchRequestForAllEntries;

#pragma mark - Summary requests
- (nonnull NSFetchRequest *)fetchRequestForYearlySummary;
- (nonnull NSFetchRequest *)fetchRequestForMonthlySummary;
- (nonnull NSFetchRequest *)fetchRequestForDaylySummary;
- (nonnull NSFetchRequest *)fetchRequestForIndividualEntriesSummary;
/*!
 @discussion category can be either a Tag instance or an NSString instance signifying 'No filter'
 */
- (void)modifyfetchRequest:(nonnull NSFetchRequest <NSFetchRequestResult>*)request toFilterByCategory:(nullable id)category;

#pragma mark - Line Graph requests
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphYearlySurplusFetchRequest;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphYearlyExpensesFetchRequest;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphMonthlySurplusFetchRequestForSectionName:(nonnull NSString *)sectionName;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphMonthlyExpensesFetchRequestForSectionName:(nonnull NSString *)sectionName;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphDailySurplusFetchRequestForSectionName:(nonnull NSString *)sectionName;
- (nonnull NSFetchRequest <NSFetchRequestResult>*)graphDailyExpensesFetchRequestForSectionName:(nonnull NSString *)sectionName;

#pragma mark - Pie Chart Graph requests
- (nonnull NSFetchRequest *)expensesByCategoryMonthlyFetchRequest;

// TODO: Document what it means to havemonth as an optional
- (nonnull NSArray <BSPieChartSectionInfo *>*)expensesByCategoryForMonth:(nullable NSNumber *)month inYear:(nonnull NSNumber *)year;


#pragma mark - Other requests
- (nonnull NSFetchRequest *)requestToGetYears;

#pragma mark - Execution of requests

/**
 Executes a fetch request and returns the results in an array.

 @param request Fetch request to be run.
 @param error Optional error if something went wrong.
 @return Returns an array of fetched results. Nil if there was an error. Only in that case error should be consulted.
 */
- (nullable NSArray *)resultsForRequest:(nonnull NSFetchRequest *)request error:(NSError *_Nullable *_Nullable)error;

#pragma mark - Tags


/**
 Returns a Tag object representing a given name

 @param tagName The name of the tag being fetched.
 @return A tag for the given name or nil if the name was not recognised.
 */
- (nullable Tag *)tagForName:(nonnull NSString *)tagName;



/**
 @discussion Ordered by name ASC.
 @return All tags available.
 */
- (nonnull NSArray<BSExpenseCategory *> *)allTags;
- (nonnull NSArray *)allTagImages;
- (nullable UIImage *)imageForCategory:(nullable Tag *)tag;
- (nullable UIImage *)imageForCategoryName:(nullable NSString *)tagName;
- (BOOL)findNoTags:(nonnull NSString *)tagName;
- (NSArray <Tag *>*)categoriesForMonth:(nullable NSNumber *)month inYear:(NSNumber *)year;
//- (nullable NSArray <BSExpenseCategory *>*)sortedTagsByPercentageFromSections:(nonnull NSArray <BSExpenseCategory *>*)tags sections:(nullable NSArray <BSPieChartSectionInfo *> *)sections;


// PUBLIC API
- (NSFetchedResultsController *_Nonnull)fetchedResultsControllerForEntriesGroupedByYear;
- (NSFetchedResultsController *_Nonnull)fetchedResultsControllerForEntriesGroupedByMonth;
- (NSFetchedResultsController *_Nonnull)fetchedResultsControllerForEntriesGroupedByDay;
- (NSFetchedResultsController *_Nonnull)fetchedResultsControllerForAllEntries;

@end
