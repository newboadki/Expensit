//
//  BSPerMonthExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSDailyExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSDailyEntryHeaderView.h"
#import "BSDailySummanryEntryCell.h"
#import "DateTimeHelper.h"
#import "BSAddEntryViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"


@interface BSDailyExpensesSummaryViewController ()

@end

@implementation BSDailyExpensesSummaryViewController


#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSString *monthString = [sectionInfo name];
    NSArray *components = [monthString componentsSeparatedByString:@"/"];
    
    NSRange numberOfDaysInMonth = [DateTimeHelper numberOfDaysInMonth:components[0]];
    return numberOfDaysInMonth.length;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSArray *fetchedObjectsForSection = [sectionInfo objects];
    NSPredicate *itemForDayPredicate = [NSPredicate predicateWithFormat:@"day = %d AND monthYear = %@", indexPath.row + 1, sectionInfo.name];
    NSDictionary *itemForDayMonthYear = [[fetchedObjectsForSection filteredArrayUsingPredicate:itemForDayPredicate] lastObject];

    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    // Determine the text of the labels
    NSString *monthLabelText = nil;
    NSString *valueLabeltext = nil;

    if (itemForDayMonthYear)
    {
        monthLabelText = [[itemForDayMonthYear valueForKey:@"day"] stringValue];
        valueLabeltext = [[BSCurrencyHelper amountFormatter] stringFromNumber:[itemForDayMonthYear valueForKey:@"dailySum"]];
    }
    else
    {
        monthLabelText = [@(indexPath.row + 1) stringValue];
        valueLabeltext = @"";
    }

    
    // configure the cell
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;
    cell.amount = [itemForDayMonthYear valueForKey:@"dailySum"];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BSDailyEntryHeaderView" forIndexPath:indexPath];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    headerView.titleLabel.text = sectionInfo.name;
    
    return headerView;
}



#pragma mark - BSCoreDataControllerDelegate

- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest {
    [super configureFetchRequest:fetchRequest];
    
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
}


- (NSString*) sectionNameKeyPath
{
    return @"monthYear";
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addEntryFromDay"])
    {
        UINavigationController *navController =(UINavigationController*)segue.destinationViewController;
        BSAddEntryViewController *addEntryVC = (BSAddEntryViewController*)navController.topViewController;
        addEntryVC.coreDataStackHelper = self.coreDataStackHelper;
    }
    else if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
        dailyExpensesViewController.sectionToBeShownIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        NSError *surplusFetchError = nil;
        NSError *expensesFetchError = nil;
        NSArray *surplusResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self graphSurplusFetchRequest] error:&surplusFetchError];
        NSArray *expensesResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self graphExpensesFetchRequest] error:&expensesFetchError];
        
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setMoneyIn:[self dataForGraphWithFetchRequestResults:surplusResults]];
        [graphViewController setMoneyOut:[self dataForGraphWithFetchRequestResults:expensesResults]];
    }
}


- (NSString*) visibleSectionName
{
    NSArray *visibleCells = [self.collectionView visibleCells];
    int visibleCellsCount = [visibleCells count];
    BSBaseExpenseCell *middleCell = (BSBaseExpenseCell *)visibleCells[(int)(visibleCellsCount / 2)];
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:middleCell];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];

    return [sectionInfo name];
}

#pragma mark - Graph Data

- (NSFetchRequest *) graphSurplusFetchRequest
{
    NSFetchRequest *fetchRequest = [super graphFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value >= 0 AND monthYear LIKE %@", [self visibleSectionName]]];
    return fetchRequest;
}


- (NSFetchRequest *) graphExpensesFetchRequest
{
    NSFetchRequest *fetchRequest = [self graphFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0 AND monthYear LIKE %@", [self visibleSectionName]]];
    return fetchRequest;
}


- (NSArray *) dataForGraphWithFetchRequestResults:(NSArray*) monthlyExpensesResults
{
    NSMutableArray *graphData = [NSMutableArray array];
    NSArray *visibleCells = [self.collectionView visibleCells];
    int visibleCellsCount = [visibleCells count];
    BSBaseExpenseCell *middleCell = (BSBaseExpenseCell *)visibleCells[(int)(visibleCellsCount / 2)];
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:middleCell];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSString *sectionName = [sectionInfo name];
    NSArray *components = [sectionName componentsSeparatedByString:@"/"];
    NSString *monthNumberString = components[0];
    
    NSRange numberOfDaysInMonth = [DateTimeHelper numberOfDaysInMonth:monthNumberString]; // What should the current month be? the
    
    for (int dayNumber = 1; dayNumber<=numberOfDaysInMonth.length; dayNumber++)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %d", dayNumber];
        NSArray *filteredResults = [monthlyExpensesResults filteredArrayUsingPredicate:predicate];
        NSDictionary *monthDictionary = [filteredResults lastObject];
        
        if (monthDictionary)
        {
            NSNumber *value = monthDictionary[@"dailySum"];
            if ([value compare:@0] == NSOrderedAscending)
            {
                value = [NSNumber numberWithFloat:-[value floatValue]];
            }
            [graphData addObject:value];
        }
        else
        {
            [graphData addObject:@0.0];
        }
    }
    
    return graphData;
}



@end
