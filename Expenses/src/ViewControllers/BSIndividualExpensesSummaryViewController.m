//
//  BSDailyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSIndividualExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSDailySummanryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "BSAddEntryViewController.h"
#import "DateTimeHelper.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"

@interface BSIndividualExpensesSummaryViewController ()

@end

@implementation BSIndividualExpensesSummaryViewController

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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *managedObject = (Entry*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];

    // configure the cell
    cell.title.text = managedObject.desc;
    cell.amountLabel.text = [[BSCurrencyHelper amountFormatter] stringFromNumber:managedObject.value];
    cell.amount = managedObject.value;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSArray *components = [sectionInfo.name componentsSeparatedByString:@"/"];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [components objectAtIndex:0], [DateTimeHelper monthNameForMonthNumber:[NSDecimalNumber decimalNumberWithString:[components objectAtIndex:1]]]];
    
    return headerView;
    
}


- (BOOL) shouldScrollToSelectedSection
{
    return YES;
}


- (NSString *) reuseIdentifierForHeader
{
    return @"BSDailyEntryHeaderView";
}


#pragma mark - BSCoreDataControllerDelegate

- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest {
    [super configureFetchRequest:fetchRequest];
}


- (NSString*) sectionNameKeyPath
{
    return @"dayAndMonth";
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addEntryFromEntry"])
    {
        UINavigationController *navController =(UINavigationController*)segue.destinationViewController;
        BSAddEntryViewController *addEntryVC = (BSAddEntryViewController*)navController.topViewController;
        addEntryVC.coreDataStackHelper = self.coreDataStackHelper;
    }
    else if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
    } else if ([[segue identifier] isEqualToString:@"DisplayGraphView"]) {
        NSPredicate *surplusPredicate = [NSPredicate predicateWithFormat:@"self >= 0"];
        NSPredicate *expensesPredicate = [NSPredicate predicateWithFormat:@"self < 0"];
        NSArray *moneyIn = [self.fetchedResultsController.fetchedObjects valueForKeyPath:@"value"];
        moneyIn = [moneyIn filteredArrayUsingPredicate:surplusPredicate];

        NSArray *moneyOut = [self.fetchedResultsController.fetchedObjects valueForKeyPath:@"value"];
        moneyIn = [moneyOut filteredArrayUsingPredicate:expensesPredicate];
    }
}

@end
