//
//  BSCoreDataController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCoreDataController.h"
#import "CoreDataStackHelper.h"
#import "Tag.h"
#import "Entry.h"
#import "BSPieChartSectionInfo.h"
#import "Expensit-Swift.h"
#import <CoreData/CoreData.h>
@import DateAndTime;

@interface BSCoreDataController ()
@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation BSCoreDataController


- (id)initWithEntityName:(NSString *)entityName coreDataHelper:(CoreDataStackHelper*)coreDataHelper
{
    self = [super init];
    if (self)
    {
        _entityName = [entityName copy];
        _coreDataHelper = coreDataHelper;
    }
    
    return self;
}

- (Entry *) newEntry
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    Entry *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

    // Configure
    newManagedObject.date = [NSDate date];
    newManagedObject.day = [NSNumber numberWithInteger:[DateConversion dayOfDateUsingCurrentCalendar:newManagedObject.date]];
    newManagedObject.month = [NSNumber numberWithInteger:[DateConversion monthOfDateUsingCurrentCalendar:newManagedObject.date]];
    newManagedObject.year = [NSNumber numberWithInteger:[DateConversion yearOfDateUsingCurrentCalendar:newManagedObject.date]];
    newManagedObject.monthYear = [NSString stringWithFormat:@"%@/%@", [newManagedObject.month stringValue], [newManagedObject.year stringValue]];
    newManagedObject.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [newManagedObject.day stringValue], [newManagedObject.month stringValue], [newManagedObject.year stringValue]];
    newManagedObject.yearMonthDay = [NSString stringWithFormat:@"%@/%@/%@", [newManagedObject.year stringValue], [newManagedObject.month stringValue], [newManagedObject.day stringValue]];

    newManagedObject.tag = [self tagForName:@"Other"];
    
    return newManagedObject;
}


- (void) insertNewEntryWithDate:(NSDate*)date description:(NSString*)description value:(NSString*)value category:(Tag *)tag
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    Entry *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // Configure    
    newManagedObject.date = date;
    newManagedObject.day = [NSNumber numberWithInteger:[DateConversion dayOfDateUsingCurrentCalendar:date]];
    newManagedObject.month = [NSNumber numberWithInteger:[DateConversion monthOfDateUsingCurrentCalendar:date]];
    newManagedObject.year = [NSNumber numberWithInteger:[DateConversion yearOfDateUsingCurrentCalendar:date]];
    newManagedObject.monthYear = [NSString stringWithFormat:@"%@/%@", [newManagedObject.month stringValue], [newManagedObject.year stringValue]];
    newManagedObject.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [newManagedObject.day stringValue], [newManagedObject.month stringValue], [newManagedObject.year stringValue]];
    newManagedObject.yearMonthDay = [NSString stringWithFormat:@"%@/%@/%@", [newManagedObject.year stringValue], [newManagedObject.month stringValue], [newManagedObject.day stringValue]];


    newManagedObject.desc = description;
    
    NSDecimalNumberHandler *roundingHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    newManagedObject.value = [[NSDecimalNumber decimalNumberWithString:value] decimalNumberByRoundingAccordingToBehavior:roundingHandler];
    newManagedObject.tag = tag;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)discardChanges
{
    [self.coreDataHelper.managedObjectContext rollback];
}


- (BOOL)saveChanges
{   
    return [self.coreDataHelper.managedObjectContext save:nil];
}


- (BOOL) saveEntry:(Entry *)entry error:(NSError **)error {
    
    BOOL saved = [self.coreDataHelper.managedObjectContext save:error];
    return saved;
}


- (void)deleteModel:(id)model
{
    [self.coreDataHelper.managedObjectContext deleteObject:model];
}

- (BOOL)createTags:(NSArray *)tags
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(Tag.class) inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    
    for (NSString *tagName in tags)
    {
        Tag *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        newManagedObject.name = tagName;
    }
    
    // Save the context.
    NSError *error = nil;
    return [context save:&error];
}


- (BOOL)setTagForAllEntriesTo:(NSString *)tagName
{
    NSError *err = nil;
    NSArray *allEntries = [self.coreDataHelper.managedObjectContext executeFetchRequest:[self fetchRequestForIndividualEntriesSummary] error:&err];
    Tag *tag = [self tagForName:tagName];
    for (Entry *entry in allEntries)
    {
        [entry setTag:tag];
    }
    
    return (err == nil);
}


- (BOOL)setOtherTagForAllEntriesWithoutTag
{
    NSError *err = nil;
    NSArray *allEntries = [self.coreDataHelper.managedObjectContext executeFetchRequest:[self fetchRequestForIndividualEntriesSummary] error:&err];
    Tag *tag = [self tagForName:@"Other"];
    for (Entry *entry in allEntries)
    {
        if (!entry.tag)
        {
            [entry setTag:tag];
        }
        
    }
    
    return (err == nil);
}


- (BOOL)findNoTags:(NSString *)tagName
{
    NSError *err = nil;
    NSArray *allEntries = [self.coreDataHelper.managedObjectContext executeFetchRequest:[self fetchRequestForIndividualEntriesSummary] error:&err];
    
    int count = 0;
    for (Entry *entry in allEntries)
    {
        if (!entry.tag)
        {
            count++;
        }
        
    }
    
    return (err == nil);
}


- (BOOL)setIsAmountNegativeFromSignOfAmount
{
    NSError *err = nil;
    NSArray *allEntries = [self.coreDataHelper.managedObjectContext executeFetchRequest:[self fetchRequestForIndividualEntriesSummary] error:&err];
    
    for (Entry *entry in allEntries)
    {
        switch ([entry.value compare:@0])
        {
            case NSOrderedAscending: // value is negative
                entry.isAmountNegative = @(YES);
                break;
            case NSOrderedDescending: // value is positive
                entry.isAmountNegative = @(NO);
                break;
            default:
                entry.isAmountNegative = @(YES); // Shouldn't happen because validation should prevent negative values from being saved
                break;
        }
    }
    
    return (err == nil);
}


- (Tag *)tagForName:(NSString *)tagName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(Tag.class) inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name LIKE %@", tagName]];
    NSError *err = nil;
    Tag *result = [[self resultsForRequest:fetchRequest error:&err] lastObject];
    if (err) {
        NSLog(@"---=A %@", err);
    }
    return result;
}

- (NSArray<ExpenseCategory *> *)allTags
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(Tag.class) inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *err = nil;
    NSArray *result = [self resultsForRequest:fetchRequest error:&err];
    
    NSMutableArray<ExpenseCategory *> *entities = [NSMutableArray array];
    for (Tag *t in result) {
        ExpenseCategory *cat  = [[ExpenseCategory alloc] initWithName:t.name iconName:t.iconImageName color:t.color];
        [entities addObject:cat];
    }
    return entities;
}

- (NSArray *)allTagImages
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (ExpenseCategory *tag in [self allTags])
    {
        [images addObject:[self imageForCategoryName:tag.iconName]];
    }
    
    return [NSArray arrayWithArray:images];
}

- (UIImage *)imageForCategory:(Tag *)tag
{
    return [self imageForCategoryName:tag.iconImageName];
}

- (nullable UIImage *)imageForCategoryName:(nullable NSString *)tagName
{
    if (!tagName)
    {
        return [[UIImage imageNamed:@"filter_all.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else
    {
        return [[UIImage imageNamed:tagName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}


- (NSArray <Tag *>*)categoriesForMonth:(nullable NSNumber *)month inYear:(NSNumber *)year
{
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self commonConfigureFetchResquest:fetchRequest];

    // Predicate
    // Predicate
    NSString *datePredicateString = [NSString stringWithFormat:@"year = %@", year];
    if (month)
    {
        datePredicateString = [datePredicateString stringByAppendingString:[NSString stringWithFormat:@" AND month = %@", month]];
    }
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:datePredicateString]];

    // Configure
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *tagDescription = propertiesByName[@"tag"];

    [fetchRequest setPropertiesToFetch:@[tagDescription]];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setResultType:NSDictionaryResultType];

    NSArray *results = [self resultsForRequest:fetchRequest error:nil];
    NSMutableArray *tags = [NSMutableArray array];
    for (NSDictionary *dic in results)
    {
        Tag* tag = (Tag *)[self.coreDataHelper.managedObjectContext existingObjectWithID:dic[@"tag"] error:nil];
        [tags addObject:tag];
    }
    
    return tags;

}

// Move to coredatafetchcontroller
//- (nullable NSArray <ExpenseCategory *>*)sortedTagsByPercentageFromSections:(nonnull NSArray <ExpenseCategory *>*)tags sections:(nullable NSArray <BSPieChartSectionInfo *> *)sections {
//    NSMutableArray *results = [NSMutableArray array];
//    
//    for (BSPieChartSectionInfo *section in sections.reverseObjectEnumerator.allObjects)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", section.name];
//        ExpenseCategory *tag = [[tags filteredArrayUsingPredicate:predicate] firstObject];
//        if (tag)
//        {
//            [results addObject:tag];
//        }
//    }
//    
//    return results;
//}



#pragma mark - Base Request

- (NSFetchRequest *)baseFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Configure the request
    [self commonConfigureFetchResquest:fetchRequest];
    
    return fetchRequest;
    
}

- (void)commonConfigureFetchResquest:(NSFetchRequest *)fetchRequest {
    // Batch Size
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
}

- (void)configureForIndividualEntriesFetchRequest:(NSFetchRequest *)fetchRequest {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"yearMonthDay" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
}

- (NSFetchRequest *)fetchRequestForAllEntries
{
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self configureForIndividualEntriesFetchRequest:fetchRequest];
    return fetchRequest;
}

#pragma mark - Requests

- (NSFetchRequest *)fetchRequestForYearlySummary {

    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self commonConfigureFetchResquest:fetchRequest];
    
    // Configure
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *yearDescription = propertiesByName[@"year"];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                   expressionForFunction:@"sum:"
                                   arguments:[NSArray arrayWithObject:keyPathExpression]];

    NSExpressionDescription *sumExpressionDescription = [[NSExpressionDescription alloc] init];
    [sumExpressionDescription setName:@"yearlySum"];
    [sumExpressionDescription setExpression:sumExpression];
    [sumExpressionDescription setExpressionResultType:NSDecimalAttributeType];

    NSExpression *dateExpression = [NSExpression expressionForKeyPath:@"date"];
    NSExpression *minDateExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:dateExpression]];
    NSExpressionDescription *minDateExpressionDescription = [[NSExpressionDescription alloc] init];
    [minDateExpressionDescription setName:@"date"];
    [minDateExpressionDescription setExpression:minDateExpression];
    [minDateExpressionDescription setExpressionResultType:NSDateAttributeType];

    [fetchRequest setPropertiesToFetch:@[yearDescription, sumExpressionDescription, minDateExpressionDescription]];
    [fetchRequest setPropertiesToGroupBy:@[yearDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];

    return fetchRequest;
}


- (NSFetchRequest *)fetchRequestForMonthlySummary {
    
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self commonConfigureFetchResquest:fetchRequest];

    // Configure
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *monthDescription = propertiesByName[@"month"];
    NSPropertyDescription *yearDescription = propertiesByName[@"year"];
    
    NSExpression *keyPathExpression = [NSExpression
                                       expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                   expressionForFunction:@"sum:"
                                   arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *sumExpressionDescription = [[NSExpressionDescription alloc] init];
    [sumExpressionDescription setName:@"monthlySum"];
    [sumExpressionDescription setExpression:sumExpression];
    [sumExpressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    NSExpression *dateExpression = [NSExpression expressionForKeyPath:@"date"];
    NSExpression *minDateExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:dateExpression]];
    NSExpressionDescription *minDateExpressionDescription = [[NSExpressionDescription alloc] init];
    [minDateExpressionDescription setName:@"date"];
    [minDateExpressionDescription setExpression:minDateExpression];
    [minDateExpressionDescription setExpressionResultType:NSDateAttributeType];

    [fetchRequest setPropertiesToFetch:@[monthDescription, yearDescription, sumExpressionDescription, minDateExpressionDescription]];
    [fetchRequest setPropertiesToGroupBy:@[monthDescription, yearDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    return fetchRequest;
}


- (NSFetchRequest *)fetchRequestForDaylySummary {
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self commonConfigureFetchResquest:fetchRequest];

    // Configure
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *dayMonthYearDescription = propertiesByName[@"dayMonthYear"];
    NSPropertyDescription *dayDescription = propertiesByName[@"day"];
    NSPropertyDescription *monthYearDescription = propertiesByName[@"monthYear"];
    
    NSExpression *keyPathExpression = [NSExpression
                                       expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                   expressionForFunction:@"sum:"
                                   arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *sumExpressionDescription =
    [[NSExpressionDescription alloc] init];
    [sumExpressionDescription setName:@"dailySum"];
    [sumExpressionDescription setExpression:sumExpression];
    [sumExpressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    NSExpression *dateExpression = [NSExpression expressionForKeyPath:@"date"];
    NSExpression *minDateExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:dateExpression]];
    NSExpressionDescription *minDateExpressionDescription = [[NSExpressionDescription alloc] init];
    [minDateExpressionDescription setName:@"date"];
    [minDateExpressionDescription setExpression:minDateExpression];
    [minDateExpressionDescription setExpressionResultType:NSDateAttributeType];

    [fetchRequest setPropertiesToFetch:@[monthYearDescription, dayMonthYearDescription,dayDescription, sumExpressionDescription, minDateExpressionDescription]];
    [fetchRequest setPropertiesToGroupBy:@[dayMonthYearDescription, monthYearDescription, dayDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];

    return fetchRequest;
}


- (NSFetchRequest *)fetchRequestForIndividualEntriesSummary {
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self configureForIndividualEntriesFetchRequest:fetchRequest];
    return fetchRequest;
}

// (NSFetchRequest <NSFetchRequestResult*)
- (void)modifyfetchRequest:(id)request toFilterByCategory:(id)category
{
    NSPredicate *predicate = nil;
    
    if (category)
    {
        Tag *tag = (Tag *)category;
        predicate = [NSPredicate predicateWithFormat:@"tag.name LIKE %@", [tag name]];
    }

    [request setPredicate:predicate];
}


#pragma mark - Line Graphs Requests

- (NSFetchRequest *) graphYearlySurplusFetchRequest
{
    NSFetchRequest *fetchRequest = [self fetchRequestForYearlySummary];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value >= 0"]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];

    return fetchRequest;
}


- (NSFetchRequest *) graphYearlyExpensesFetchRequest
{
    NSFetchRequest *fetchRequest = [self fetchRequestForYearlySummary];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0"]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];

    return fetchRequest;
}


- (NSFetchRequest *)graphMonthlySurplusFetchRequestForSectionName:(NSString *)sectionName {
    NSFetchRequest *fetchRequest = [self fetchRequestForMonthlySummary];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value >= 0 AND year LIKE %@", sectionName]];
    return fetchRequest;
}


- (NSFetchRequest *)graphMonthlyExpensesFetchRequestForSectionName:(NSString *)sectionName {
    NSFetchRequest *fetchRequest = [self fetchRequestForMonthlySummary];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0 AND year LIKE %@", sectionName]];
    return fetchRequest;
}


- (NSFetchRequest *)graphDailySurplusFetchRequestForSectionName:(NSString *)sectionName {
    NSFetchRequest *fetchRequest = [self fetchRequestForDaylySummary];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value >= 0 AND monthYear LIKE %@", sectionName]];
    return fetchRequest;
}


- (NSFetchRequest *)graphDailyExpensesFetchRequestForSectionName:(NSString *)sectionName {
    NSFetchRequest *fetchRequest = [self fetchRequestForDaylySummary];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0 AND monthYear LIKE %@", sectionName]];
    return fetchRequest;
}


- (NSFetchRequest *)requestToGetYears {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *yearDescription = propertiesByName[@"year"];
    
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:@[yearDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    return fetchRequest;
}



#pragma mark - Pie Chart Graph requests

- (NSFetchRequest *)expensesByCategoryMonthlyFetchRequest
{
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self commonConfigureFetchResquest:fetchRequest];
    
    
    // Configure
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *monthDescription = propertiesByName[@"month"];
    NSPropertyDescription *yearDescription = propertiesByName[@"year"];
    NSPropertyDescription *tagDescription = propertiesByName[@"tag"];
    
    NSExpression *keyPathExpression = [NSExpression
                                       expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                   expressionForFunction:@"sum:"
                                   arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *sumExpressionDescription = [[NSExpressionDescription alloc] init];
    [sumExpressionDescription setName:@"monthlyCategorySum"];
    [sumExpressionDescription setExpression:sumExpression];
    [sumExpressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:@[tagDescription, monthDescription, yearDescription, sumExpressionDescription]];
    [fetchRequest setPropertiesToGroupBy:@[tagDescription, monthDescription, yearDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    return fetchRequest;
}


- (nonnull NSArray <BSPieChartSectionInfo *>*)expensesByCategoryForMonth:(nullable NSNumber *)month inYear:(nonnull NSNumber *)year
{
    NSArray *tags = [self allTags];
    NSMutableArray *absoluteAmountPerTag = [NSMutableArray arrayWithCapacity:[tags count]];
    NSUInteger i = 0;
    
    for (Tag *tag in tags)
    {
        CGFloat absoluteAmount = [self absoluteSumOfEntriesForCategoryName:tag.name fromMonth:month inYear:year];
        absoluteAmountPerTag[i] = @(absoluteAmount);
        i++;
    }
    
    
    CGFloat total = 0;
    for (NSNumber *number in absoluteAmountPerTag)
    {
        total += [number floatValue];
    }
    
    
    i = 0;
    CGFloat percentageSum = 0;
    NSMutableArray *sections = [NSMutableArray array];
    for (NSNumber *amount in absoluteAmountPerTag)
    {
        BSPieChartSectionInfo *info = [[BSPieChartSectionInfo alloc] init];
        Tag *tag = tags[i];
        info.name = [tag name];
        info.percentage = ([amount floatValue] / total);
        percentageSum += info.percentage;
        info.color = tag.color;
        i++;
        [sections addObject:info];
    }
    
    NSSortDescriptor *orderASC = [NSSortDescriptor sortDescriptorWithKey:@"percentage" ascending:YES];
    [sections sortUsingDescriptors:@[orderASC]];
    NSMutableArray *sectionsCopy = [NSMutableArray array];
    
    for (BSPieChartSectionInfo *sec in sections)
    {
        if (sec.percentage != 0)
        {
            [sectionsCopy addObject:sec];
        }
    }
    
    return sectionsCopy;
}

- (CGFloat)absoluteSumOfEntriesForCategoryName:(NSString *)name fromMonth:(NSNumber *)month inYear:(NSNumber *)year
{
    // Get a base request
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    [self commonConfigureFetchResquest:fetchRequest];
    
    // Predicate
    NSString *datePredicateString = [NSString stringWithFormat:@"year = %@", year];
    if (month)
    {
        datePredicateString = [datePredicateString stringByAppendingString:[NSString stringWithFormat:@" AND month = %@", month]];
    }
    NSPredicate *incomePredicate = [NSPredicate predicateWithFormat:[datePredicateString stringByAppendingString:@" AND tag.name LIKE %@ AND value > 0"], name];
    NSPredicate *expensesPredicate = [NSPredicate predicateWithFormat:[datePredicateString stringByAppendingString:@" AND tag.name LIKE %@ AND value < 0"], name];

    [fetchRequest setPredicate:incomePredicate];
    
    // Configure
    NSExpression *keyPathExpression = [NSExpression
                                       expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                   expressionForFunction:@"sum:"
                                   arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *absoluteSumExpressionDescription = [[NSExpressionDescription alloc] init];
    [absoluteSumExpressionDescription setName:@"monthlyCategoryAbsoluteSum"];
    [absoluteSumExpressionDescription setExpression:sumExpression];
    [absoluteSumExpressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:@[absoluteSumExpressionDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSArray *results = [self resultsForRequest:fetchRequest error:nil];
    CGFloat income = [[[results firstObject] valueForKey:@"monthlyCategoryAbsoluteSum"] floatValue];
    
    
    [fetchRequest setPredicate:expensesPredicate];
    results = [self resultsForRequest:fetchRequest error:nil];
    CGFloat expenses = [[[results firstObject] valueForKey:@"monthlyCategoryAbsoluteSum"] floatValue];
    
    return (income + fabs(expenses));
}


#pragma mark - Execution of queries

- (NSArray *)resultsForRequest:(NSFetchRequest *)request error:(NSError **)error {
    NSArray *output = [self.coreDataHelper.managedObjectContext executeFetchRequest:request error:error];
    return output;
}

#pragma mark - ExpenseSummaryDataGatewayProtocol

#pragma mark - NSFetchResultsController

- (NSFetchedResultsController *)fetchedResultsControllerForEntriesGroupedByYear {
    NSFetchRequest *request = [self fetchRequestForYearlySummary];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.coreDataHelper.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntriesGroupedByMonth {
    NSFetchRequest *request = [self fetchRequestForMonthlySummary];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.coreDataHelper.managedObjectContext sectionNameKeyPath:@"year" cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntriesGroupedByDay {
    NSFetchRequest *request = [self fetchRequestForDaylySummary];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.coreDataHelper.managedObjectContext sectionNameKeyPath:@"monthYear" cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerForAllEntries {
    NSFetchRequest *request = [self fetchRequestForAllEntries];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.coreDataHelper.managedObjectContext sectionNameKeyPath:@"yearMonthDay" cacheName:nil];
}

@end
