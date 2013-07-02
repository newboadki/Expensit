//
//  BSPerMonthExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSPerMonthExpensesSummaryViewController.h"
#import "Entry.h"
#import "BSDailyEntryHeaderView.h"
#import "BSDailySummanryEntryCell.h"
#import "DateTimeHelper.h"
#import "BSAddEntryViewController.h"

@interface BSPerMonthExpensesSummaryViewController ()

@end

@implementation BSPerMonthExpensesSummaryViewController


#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{    
    return 30;
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
        valueLabeltext = @"--";
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
    }
}

@end
