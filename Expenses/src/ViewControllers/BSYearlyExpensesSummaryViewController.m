//
//  BSYearlyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 06/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSYearlyExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSYearlySummaryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "DateTimeHelper.h"
#import "BSAddEntryViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"

@interface BSYearlyExpensesSummaryViewController ()

@end

@implementation BSYearlyExpensesSummaryViewController

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
    return [self.fetchedResultsController.fetchedObjects count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemForMonth = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    BSYearlySummaryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    // Determine the text of the labels
    NSString *monthLabelText = nil;
    NSString *valueLabeltext = nil;
    
    if (itemForMonth)
    {
        monthLabelText = [[itemForMonth valueForKey:@"year"] stringValue];
        valueLabeltext = [[BSCurrencyHelper amountFormatter] stringFromNumber:[itemForMonth valueForKey:@"yearlySum"]];
    }
    
    // Labels
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;
    
    // Text color
    cell.amount = [itemForMonth valueForKey:@"yearlySum"];
    
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
    if ([[segue identifier] isEqualToString:@"showMonthlyEntries"])
    {
        BSBaseExpensesSummaryViewController *monthlyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        monthlyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
//        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
//        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
//        monthlyExpensesViewController.sectionToBeShownIndexPath = [NSIndexPath indexPathForRow:0 inSection:selectedIndexPath.row]; // Last month
    }
    else if ([[segue identifier] isEqualToString:@"addEntryFromYear"])
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



#pragma mark - BSCoreDataControllerDelegate

- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest
{
    [super configureFetchRequest:fetchRequest];
    
    
    // Edit the sort key as appropriate.
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
}


- (NSString*) sectionNameKeyPath
{
    return nil;
}



#pragma mark - Graph Data

- (NSArray *) dataForGraphWithFetchRequestResults:(NSArray*) yearlyExpensesResults
{
    NSMutableArray *graphData = [NSMutableArray array];
    
    for (int i = 0; i<[yearlyExpensesResults count]; i++)
    {
        NSDictionary *monthDictionary = yearlyExpensesResults[i];
        
        if (monthDictionary)
        {
            NSNumber *value = monthDictionary[@"yearlySum"];
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
