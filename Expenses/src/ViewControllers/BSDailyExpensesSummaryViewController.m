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
#import "BSEntryDetailsViewController.h"
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
    [cell configure];
    cell.title.text = monthLabelText;
    cell.amountLabel.text = valueLabeltext;
    cell.amount = [itemForDayMonthYear valueForKey:@"dailySum"];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    
    headerView.titleLabel.text = [DateTimeHelper monthNameAndYearStringFromMonthNumberAndYear:sectionInfo.name];
    return headerView;
}


- (BOOL) shouldScrollToSelectedSection
{
    return YES;
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // We want a section To fill 5/6 of the viewController's view
    NSString *monthNumber = [[self visibleSectionName] componentsSeparatedByString:@"/"][0];
    NSRange numberOfDaysInMonthRange = [DateTimeHelper numberOfDaysInMonth:monthNumber];
    NSInteger numberIfDaysInMonth = numberOfDaysInMonthRange.length;

    NSInteger numberOfColumns = 6;
    CGFloat numberOfRows = (numberIfDaysInMonth / numberOfColumns);
    CGFloat sectionHeight = self.view.bounds.size.height * 0.67;
    CGFloat cellWidth = (self.view.bounds.size.width / numberOfColumns);
    CGFloat cellHeight = (sectionHeight / numberOfRows);
    return CGSizeMake(cellWidth, cellHeight);
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
        BSEntryDetailsViewController *addEntryVC = (BSEntryDetailsViewController*)navController.topViewController;
        addEntryVC.coreDataStackHelper = self.coreDataStackHelper;
    }
    else if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {
        BSBaseExpensesSummaryViewController *dailyExpensesViewController = (BSBaseExpensesSummaryViewController*)segue.destinationViewController;
        dailyExpensesViewController.coreDataStackHelper = self.coreDataStackHelper;
        
        UICollectionViewCell *selectedCell = (UICollectionViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:selectedIndexPath.section];
        
        // Create the name of the section to go to in the next VC
        NSString *month = [sectionInfo.name componentsSeparatedByString:@"/"][0];
        NSString *year = [sectionInfo.name componentsSeparatedByString:@"/"][1];
        
        
        NSString *sectionNameToScrollTo = [NSString stringWithFormat:@"%@/%@/%d", year, month, selectedIndexPath.row + 1];
        dailyExpensesViewController.nameOfSectionToBeShown = sectionNameToScrollTo;
    }
    else if ([[segue identifier] isEqualToString:@"DisplayGraphView"])
    {
        NSError *surplusFetchError = nil;
        NSError *expensesFetchError = nil;
        NSArray *surplusResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self graphSurplusFetchRequest] error:&surplusFetchError];
        NSArray *expensesResults = [self.coreDataStackHelper.managedObjectContext executeFetchRequest:[self graphExpensesFetchRequest] error:&expensesFetchError];
        
        BSGraphViewController *graphViewController = (BSGraphViewController *)[segue destinationViewController];
        [graphViewController setGraphTitle:[DateTimeHelper monthNameAndYearStringFromMonthNumberAndYear:[self visibleSectionName]]];
        [graphViewController setMoneyIn:[self dataForGraphWithFetchRequestResults:surplusResults]];
        [graphViewController setMoneyOut:[self dataForGraphWithFetchRequestResults:expensesResults]];
        [graphViewController setXValues:[self arrayDayNumbersInMonth]];
    }
}



- (NSString *) reuseIdentifierForHeader
{
    return @"BSDailyEntryHeaderView";
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


- (NSArray *) dataForGraphWithFetchRequestResults:(NSArray*) dailyExpensesResults
{
    NSMutableArray *graphData = [NSMutableArray array];
    NSString *monthNumber = [[self visibleSectionName] componentsSeparatedByString:@"/"][0];
    NSRange numberOfDaysInMonth = [DateTimeHelper numberOfDaysInMonth:monthNumber];
    
    for (int dayNumber = 1; dayNumber<=numberOfDaysInMonth.length; dayNumber++)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %d", dayNumber];
        NSArray *filteredResults = [dailyExpensesResults filteredArrayUsingPredicate:predicate];
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


- (NSArray *) arrayDayNumbersInMonth
{
    NSString *monthNumber = [[self visibleSectionName] componentsSeparatedByString:@"/"][0];
    NSRange numberOfDaysInMonth = [DateTimeHelper numberOfDaysInMonth:monthNumber];
    NSMutableArray *dayNumbers = [NSMutableArray array];
    
    for (int i = 1; i<=numberOfDaysInMonth.length; i++) {
        [dayNumbers addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    return dayNumbers;
}


@end
