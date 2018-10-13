//
//  BSDailyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSIndividualExpensesSummaryViewController.h"
#import "BSDailySummanryEntryCell.h"
#import "BSDailyEntryHeaderView.h"
#import "BSEntryDetailsFormViewController.h"
#import "DateTimeHelper.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "Expensit-Swift.h"

@interface BSIndividualExpensesSummaryViewController ()

@end

@implementation BSIndividualExpensesSummaryViewController

- (ExpensesSummaryType)summaryType {
    return AllEntriesExpensesSummaryType;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sections[section].numberOfEntries;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSDisplayExpensesSummaryEntry *entry = self.sections[indexPath.section].entries[indexPath.row];
    BSDailySummanryEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpenseCell" forIndexPath:indexPath];

    // configure the cell
    [cell configure];
    cell.title.text = entry.title;
    cell.amountLabel.text = entry.value;
    
    switch (entry.signOfAmount)
    {
        case BSNumberSignTypeZero:
            cell.isPositive = YES;
            break;
        case BSNumberSignTypePositive:
            cell.isPositive = YES;
            break;
        case BSNumberSignTypeNegative:
            cell.isPositive = NO;
            break;
    }

    
    return cell;
}   

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BSDailyEntryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
    BSDisplayExpensesSummarySection *sectionInfo = self.sections[indexPath.section];
    headerView.titleLabel.text = sectionInfo.title;
    
    return headerView;    
}


- (NSString *) reuseIdentifierForHeader
{
    return @"BSDailyEntryHeaderView";
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 41.0f);
}



#pragma mark - BSCoreDataControllerDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEntriesForDay"])
    {

    }
    else if ([[segue identifier] isEqualToString:@"editEntryFromEntry"])
    {
        BSIndividualEntriesSummaryNavigationTransitionManager *individualEntriesTransitionManager = (BSIndividualEntriesSummaryNavigationTransitionManager *)self.navigationTransitionManager;
        
        UICollectionViewCell *selectedCell = (UICollectionViewCell *)sender;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:selectedCell];
        [individualEntriesTransitionManager configureEditEntryViewControllerWithSegue:segue
                                                                    selectedIndexPath:selectedIndexPath
                                                                         displayEntry:self.sections[selectedIndexPath.section].entries[selectedIndexPath.row]
                                                                  allEntriesPresenter:self.showEntriesPresenter];
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }
    
}

@end
