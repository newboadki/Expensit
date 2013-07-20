//
//  BSMonthlyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 23/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSMonthlyExpensesSummaryViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "Entry.h"
#import "BSMonthlySummaryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "DateTimeHelper.h"
#import "BSAddEntryViewController.h"
#import "BSGraphViewController.h"
#import "LineGraph.h"

@interface BSMonthlyExpensesSummaryViewController ()

@end

@implementation BSMonthlyExpensesSummaryViewController



#pragma mark - View life cycle

- (void) viewDidLoad
{
    [super viewDidLoad];    
}



#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12; // We always show the 12 months, even if the request doesn't have results for each month
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSArray *fetchedObjectsForSection = [sectionInfo objects];
    NSPredicate *itemForMonthPredicate = [NSPredicate predicateWithFormat:@"month = %d", indexPath.row + 1];
    NSDictionary *itemForMonth = [[fetchedObjectsForSection filteredArrayUsingPredicate:itemForMonthPredicate] lastObject];
    
    BSMonthlySummaryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *monthLabelText = nil;
    NSString *valueLabeltext = nil;
    
    if (itemForMonth)
    {
        monthLabelText = [DateTimeHelper monthNameForMonthNumber:[itemForMonth valueForKey:@"month"]];
        valueLabeltext = [[BSCurrencyHelper amountFormatter] stringFromNumber:[itemForMonth valueForKey:@"monthlySum"]];
    }
    else
    {
        monthLabelText = [DateTimeHelper monthNameForMonthNumber:@(indexPath.row + 1)];
        valueLabeltext = @"";
    }
    
    // Labels
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;

    // Text color
    cell.amount = [itemForMonth valueForKey:@"monthlySum"];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BSDailyEntryHeaderView" forIndexPath:indexPath];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    headerView.titleLabel.text = sectionInfo.name;
    
    return headerView;
    
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDailyEntriesForMonth"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:selectedIndexPath.section];

        // Create the name of the section to go to in the next VC
        NSString *sectionNameToScrollTo = [NSString stringWithFormat:@"%d/%@", selectedIndexPath.row+1 ,sectionInfo.name]; // there are 12 months (0-11) that's why we add 1. The section name is the year
        dailyExpensesViewController.nameOfSectionToBeShown = sectionNameToScrollTo;
    }
    else if ([[segue identifier] isEqualToString:@"addEntryFromMonth"])
    {
        UINavigationController *navController =(UINavigationController*)segue.destinationViewController;
        BSAddEntryViewController *addEntryVC = (BSAddEntryViewController*)navController.topViewController;
        addEntryVC.coreDataStackHelper = self.coreDataStackHelper;
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

- (BOOL) shouldScrollToSelectedSection
{
    return YES;
}

#pragma mark - BSCoreDataControllerDelegate

- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest
{
    [super configureFetchRequest:fetchRequest];
    
    NSDictionary* propertiesByName = [[fetchRequest entity] propertiesByName];
    NSPropertyDescription *monthDescription = propertiesByName[@"month"];
    NSPropertyDescription *yearDescription = propertiesByName[@"year"];
    
    NSExpression *keyPathExpression = [NSExpression
                                       expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression
                                        expressionForFunction:@"sum:"
                                        arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *sumExpressionDescription =
    [[NSExpressionDescription alloc] init];
    [sumExpressionDescription setName:@"monthlySum"];
    [sumExpressionDescription setExpression:sumExpression];
    [sumExpressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:@[monthDescription, yearDescription, sumExpressionDescription]];
    [fetchRequest setPropertiesToGroupBy:@[monthDescription, yearDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];
}


- (NSString*) sectionNameKeyPath
{
    return @"year";
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
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value >= 0 AND year LIKE %@", [self visibleSectionName]]];
    return fetchRequest;
}


- (NSFetchRequest *) graphExpensesFetchRequest
{
    NSFetchRequest *fetchRequest = [self graphFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0 AND year LIKE %@", [self visibleSectionName]]];
    return fetchRequest;
}


- (NSArray *) dataForGraphWithFetchRequestResults:(NSArray*) monthlyExpensesResults
{
    NSMutableArray *graphData = [NSMutableArray array];
    
    for (int monthNumber = 1; monthNumber<=12; monthNumber++)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"month = %d", monthNumber];
        NSArray *filteredResults = [monthlyExpensesResults filteredArrayUsingPredicate:predicate];
        NSDictionary *monthDictionary = [filteredResults lastObject];
        
        if (monthDictionary)
        {
            NSNumber *value = monthDictionary[@"monthlySum"];
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
