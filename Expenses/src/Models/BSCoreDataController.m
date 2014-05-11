//
//  BSCoreDataController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "CoreDataStackHelper.h"
#import "Tag.h"

@interface BSCoreDataController ()
@property (strong, nonatomic) NSString *entityName;
@end

@implementation BSCoreDataController


- (id)initWithEntityName:(NSString*)entityName delegate:(id<BSCoreDataControllerDelegateProtocol>)delegate coreDataHelper:(CoreDataStackHelper*)coreDataHelper
{
    self = [super init];
    if (self)
    {
        _entityName = [entityName copy];
        _delegate = delegate;
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
    newManagedObject.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:newManagedObject.date]];
    newManagedObject.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:newManagedObject.date]];;
    newManagedObject.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:newManagedObject.date]];;
    newManagedObject.monthYear = [NSString stringWithFormat:@"%@/%@", [newManagedObject.month stringValue], [newManagedObject.year stringValue]];
    newManagedObject.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [newManagedObject.day stringValue], [newManagedObject.month stringValue], [newManagedObject.year stringValue]];
    newManagedObject.yearMonthDay = [NSString stringWithFormat:@"%@/%@/%@", [newManagedObject.year stringValue], [newManagedObject.month stringValue], [newManagedObject.day stringValue]];

    return newManagedObject;
}


- (void) insertNewEntryWithDate:(NSDate*)date description:(NSString*)description value:(NSString*)value category:(Tag *)tag
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    Entry *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // Configure    
    newManagedObject.date = date;
    newManagedObject.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:date]];
    newManagedObject.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:date]];;
    newManagedObject.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:date]];;
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
    
    BOOL isCurrentValueNegative = ([entry.value compare:@(-1)] == NSOrderedAscending);
    
    if (isCurrentValueNegative ^ [entry.isAmountNegative boolValue]) // XOR True when the inputs are different (true output means we need to multiply by -1)
    {
        if (![entry.value isEqualToNumber:[NSDecimalNumber notANumber]])
        {
            entry.value = [entry.value decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
        }
    }
    
    return [self.coreDataHelper.managedObjectContext save:error];
}


- (void)deleteModel:(id)model
{
    [self.coreDataHelper.managedObjectContext deleteObject:model];
}


- (BOOL)createTags:(NSArray *)tags
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[Tag class] description] inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[Tag class] description] inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name LIKE %@", tagName]];
    
    return [[self resultsForRequest:fetchRequest error:nil] lastObject];
}

- (NSArray *)allTags
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[[Tag class] description] inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    return [self resultsForRequest:fetchRequest error:nil];
}

- (NSArray *)allTagImages
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (Tag *tag in [self allTags])
    {
        [images addObject:[self imageForCategory:tag]];
    }
    
    return [NSArray arrayWithArray:images];
}

- (UIImage *)imageForCategory:(Tag *)tag
{
    if (!tag.iconImageName)
    {
        return [[UIImage imageNamed:@"filter_all.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else
    {
        return [[UIImage imageNamed:tag.iconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}



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
    
    NSExpression *keyPathExpression = [NSExpression
                                       expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                   expressionForFunction:@"sum:"
                                   arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *sumExpressionDescription =
    [[NSExpressionDescription alloc] init];
    [sumExpressionDescription setName:@"yearlySum"];
    [sumExpressionDescription setExpression:sumExpression];
    [sumExpressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:@[yearDescription, sumExpressionDescription]];
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
    
    [fetchRequest setPropertiesToFetch:@[monthDescription, yearDescription, sumExpressionDescription]];
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
    
    [fetchRequest setPropertiesToFetch:@[monthYearDescription, dayMonthYearDescription,dayDescription, sumExpressionDescription]];
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


- (void)modifyfetchRequest:(NSFetchRequest*)request toFilterByCategory:(id)category
{
    NSPredicate *predicate = nil;
    
    if (category)
    {
        Tag *tag = (Tag *)category;
        predicate = [NSPredicate predicateWithFormat:@"tag.name LIKE %@", [tag name]];
    }

    [request setPredicate:predicate];
}



#pragma mark - Graphs Requests

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

#pragma mark - Execution of queries

- (NSArray *) resultsForRequest:(NSFetchRequest *)request error:(NSError **)error {
    return [self.coreDataHelper.managedObjectContext executeFetchRequest:request error:error];
}

@end
