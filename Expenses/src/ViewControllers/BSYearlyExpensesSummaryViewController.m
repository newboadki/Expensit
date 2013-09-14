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
#import "BSEntryDetailsViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "BSMonthlyExpensesSummaryViewController.h"

@interface BSYearlyExpensesSummaryViewController ()
@property (strong, nonatomic) NSArray *years;
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

    [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
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
    [cell configure];
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
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        monthlyExpensesViewController.nameOfSectionToBeShown = self.fetchedResultsController.fetchedObjects[selectedIndexPath.row][@"year"];
    }
    else if ([[segue identifier] isEqualToString:@"addEntryFromYear"])
    {
        UINavigationController *navController =(UINavigationController*)segue.destinationViewController;
        BSEntryDetailsViewController *addEntryVC = (BSEntryDetailsViewController*)navController.topViewController;
        addEntryVC.coreDataStackHelper = self.coreDataStackHelper;
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        NSError *surplusFetchError = nil;
        NSError *expensesFetchError = nil;
        NSArray *surplusResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self graphSurplusFetchRequest] error:&surplusFetchError];
        NSArray *expensesResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self graphExpensesFetchRequest] error:&expensesFetchError];
        self.years = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self requestToGetYears] error:nil];
        self.years = [self.years valueForKeyPath:@"year"];
        
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setMoneyIn:[self dataForGraphWithFetchRequestResults:surplusResults]];
        [graphViewController setMoneyOut:[self dataForGraphWithFetchRequestResults:expensesResults]];
//        NSArray *yearNumbers = [self.years valueForKeyPath:@"year"];
        NSMutableArray *yearStrings = [NSMutableArray array];
        for (NSNumber *number in self.years) {
            [yearStrings addObject:[number stringValue]];
        }
        [graphViewController setXValues:yearStrings];
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

- (void) configureFetchRequestForGraph:(NSFetchRequest*)fetchRequest
{
    // Batch Size
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
}


- (NSArray *) dataForGraphWithFetchRequestResults:(NSArray*)yearlyExpensesResults
{
    NSMutableArray *graphData = [NSMutableArray array];
    
    for (int i = 0; i<[self.years count]; i++)
    {
        
        NSDictionary *monthDictionary = nil;

        for (NSDictionary *dic in yearlyExpensesResults) {
            if ([dic[@"year"] isEqualToNumber:self.years[i]]) {
                monthDictionary = dic;
                break;
            }

//            monthDictionary = [[yearlyExpensesResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.year = %@", self.years[i]]] lastObject];
        }
        
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


- (NSFetchRequest *)requestToGetYears {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataStackHelper.managedObjectContext];
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


@end
