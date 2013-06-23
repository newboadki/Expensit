//
//  BSDailyExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSDailyExpensesSummaryViewController.h"

@interface BSDailyExpensesSummaryViewController ()

@end

@implementation BSDailyExpensesSummaryViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
        self.queryDate = [NSDate date];
    [self.coreDataController insertNewEntry:@"hola"];
    [self.coreDataController insertNewEntry:@"hola"];
    [self.coreDataController insertNewEntry:@"adios"];
    [self.coreDataController insertNewEntry:@"adios"];
//    [self.coreDataController insertNewEntry:nil];
//    [self.coreDataController insertNewEntry:nil];
//    [self.coreDataController insertNewEntry:nil];
//    [self.coreDataController insertNewEntry:nil];
//    [self.coreDataController insertNewEntry:nil];
//    [self.coreDataController insertNewEntry:nil];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"--- %d", [self.coreDataController.fetchedResultsController.fetchedObjects count]);
    return [self.coreDataController.fetchedResultsController.fetchedObjects count];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [self.coreDataController.fetchedResultsController.fetchedObjects count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}



#pragma mark - BSCoreDataControllerDelegate

- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest {
    [super configureFetchRequest:fetchRequest];
    
    // Set predicate to filter dates
    NSPredicate *entriesForAGivenDayPredicate = [NSPredicate predicateWithFormat:@"date < %@", self.queryDate];
    [fetchRequest setPredicate:entriesForAGivenDayPredicate];
    
    // group by day
    NSEntityDescription *entity = [fetchRequest entity];
    NSDictionary* propertiesByName = [entity propertiesByName];
    NSPropertyDescription *descPropertyDescription = propertiesByName[@"desc"];
    NSPropertyDescription *datePropertyDescription = propertiesByName[@"date"];
    fetchRequest.resultType = NSDictionaryResultType;
    [fetchRequest setPropertiesToFetch:@[datePropertyDescription]];
    [fetchRequest setPropertiesToGroupBy:@[datePropertyDescription, descPropertyDescription]];
}

- (NSString*) sectionNameKeyPath
{
    return @"month";
}

@end
