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
        NSArray *surplusResults = [self graphSurplusResults];
        NSArray *expensesResults = [self graphExpensesResults];
        self.years = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self.coreDataController requestToGetYears] error:nil];
        self.years = [self.years valueForKeyPath:@"year"];
        
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setMoneyIn:[self dataForGraphWithFetchRequestResults:surplusResults]];
        [graphViewController setMoneyOut:[self dataForGraphWithFetchRequestResults:expensesResults]];

        NSMutableArray *yearStrings = [NSMutableArray array];
        for (NSNumber *number in self.years) {
            [yearStrings addObject:[number stringValue]];
        }
        [graphViewController setXValues:yearStrings];
    }
}



#pragma mark - BSCoreDataControllerDelegate

- (NSFetchRequest*) fetchRequest {
    return [self.coreDataController fetchRequestForYearlySummary];
}


- (NSString*) sectionNameKeyPath
{
    return nil;
}


- (NSArray *)graphSurplusResults
{
    return [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self.coreDataController graphYearlySurplusFetchRequest] error:nil];
}


- (NSArray *)graphExpensesResults
{
    return [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self.coreDataController graphYearlyExpensesFetchRequest] error:nil];
}



#pragma mark - Graph Data

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
            // why doesn't this work?
            // monthDictionary = [[yearlyExpensesResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.year = %@", self.years[i]]] lastObject];
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

@end
