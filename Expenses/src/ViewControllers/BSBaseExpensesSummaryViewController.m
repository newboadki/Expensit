//
//  BSBaseExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSBaseExpenseCell.h"
#import "DateTimeHelper.h"
#import "BSGraphViewController.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"

@interface BSBaseExpensesSummaryViewController ()
@property (nonatomic) BOOL isShowingLandscapeView;
@end

@implementation BSBaseExpensesSummaryViewController


#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstTimeViewWillAppear = YES;
    
    // Do any additional setup after loading the view from its nib.
    
    BSAppDelegate *delegate = (BSAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.coreDataStackHelper = delegate.coreDataHelper;
    
    // Prepare for Landscape
    self.isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    // TODO: differenciate between ios7 and 6
    // self.edgesForExtendedLayout = UIRectEdgeAll;
    // [[self.navigationController navigationBar] setTintColor:[UIColor redColor]];

}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];
    
    

    if (self.shouldScrollToSelectedSection && self.firstTimeViewWillAppear)
    {
        self.firstTimeViewWillAppear = NO;
        NSArray *sectionNames = [self.fetchedResultsController.fetchedObjects valueForKeyPath:[self sectionNameKeyPath]];
        NSMutableArray* uniqueSectionNames = [[NSMutableArray alloc] init];
        for(id sectionName in sectionNames)
        {
            if(![uniqueSectionNames containsObject:sectionName])
            {
                [uniqueSectionNames addObject:sectionName];
            }
        }
        NSArray *filteredArray = [uniqueSectionNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self = %@", self.nameOfSectionToBeShown]];
        NSInteger sectionToScrollTo = [uniqueSectionNames indexOfObject:[filteredArray lastObject]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionToScrollTo];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        UIView *header = (UIView *)[self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
        CGPoint offset = self.collectionView.contentOffset;
        offset.y -= header.frame.size.height;
        self.collectionView.contentOffset = offset;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Landscape Presentation

- (void)orientationChanged:(NSNotification *)notification
{
    if (self == [[self navigationController] topViewController]) {
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsLandscape(deviceOrientation) && !self.isShowingLandscapeView)
        {
            [self performSegueWithIdentifier:@"DisplayGraphView" sender:[[self navigationController] topViewController]];
            self.isShowingLandscapeView = YES;
        }
        else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView && [self.presentedViewController isKindOfClass:[BSGraphViewController class]])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            self.isShowingLandscapeView = NO;
        }
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - UICollectionView

- (IBAction) cancelAddEntry:(UIStoryboardSegue*)segue
{
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSBaseExpenseCell *cell = (BSBaseExpenseCell*)[collectionView cellForItemAtIndexPath:indexPath];
    return (cell.amountLabel.text && (cell.amountLabel.text.length > 0));
}


- (NSString*) visibleSectionName
{
    //TODO: IN case of a TIE, choose the section with the newest date
    NSArray *visibleCells = [self.collectionView visibleCells];
    NSMutableDictionary *occurences = [NSMutableDictionary dictionary];
    for (UICollectionViewCell *cell in visibleCells)
    {
        NSNumber *sectionNumber = [NSNumber numberWithInt:[self.collectionView indexPathForCell:cell].section];
        NSNumber * count = occurences[sectionNumber];
        if (count)
        {
            count = [NSNumber numberWithInt:[count intValue] + 1];
        }
        else
        {
            count = @1;
        }
        
        occurences[sectionNumber] = count;
    }
    
    
    // Find the max in the ocurrences dictionary
    NSNumber *sectionWithMostVisibleCells = nil;
    for (id key in [occurences allKeys])
    {
        if (sectionWithMostVisibleCells)
        {
            NSComparisonResult comparisonResult = [occurences[key] compare:occurences[sectionWithMostVisibleCells]];
            if ((comparisonResult == NSOrderedDescending) || (comparisonResult == NSOrderedSame)) // To un-tie. This makes some asumptions, like that the cells are ordered ascending, and that we are presenting the calendar ascending.. 2012 at the top... 2013 if you scroll down
            {
                sectionWithMostVisibleCells = key;
            }
        }
        else
        {
            // first iteration, set current key to be the maximum
            sectionWithMostVisibleCells = key;
        }
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:[sectionWithMostVisibleCells intValue]];
    
    return sectionInfo.name;
}

- (NSString*) reuseIdentifierForHeader
{
    @throw @"Implement in subclasses";
}



#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create the request
    NSFetchRequest *fetchRequest = [self fetchRequest];
    
    // FetchedResultsController
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.coreDataStackHelper.managedObjectContext
                                                                      sectionNameKeyPath:self.sectionNameKeyPath
                                                                               cacheName:nil];

    //_fetchedResultsController.delegate = self;
    
    // Execute the request
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error fetching results. %@, %@", error, [error userInfo]);
	    abort();
	}
    else
    {
        
    }
    
    return _fetchedResultsController;
}


- (NSFetchRequest*) fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataStackHelper.managedObjectContext];
    [fetchRequest setEntity:entity];    
    
    // Configure the request
    [self configureFetchRequest:fetchRequest];
    
    return fetchRequest;
}


- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest
{
    // Batch Size
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
}


- (void) configureFetchRequestForGraph:(NSFetchRequest*)fetchRequest
{
    // Batch Size
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
}


- (NSString*) sectionNameKeyPath
{
    @throw @"Implement in subclasses";
    return nil;
}



#pragma mark - Core Data Graph queries

- (NSFetchRequest *) graphFetchRequest
{
    NSFetchRequest *fetchRequest = [self fetchRequest];
    [self configureFetchRequest:fetchRequest];
    return fetchRequest;
}


- (NSFetchRequest *) graphSurplusFetchRequest
{
    NSFetchRequest *fetchRequest = [self graphFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value >= 0"]];
    [self configureFetchRequestForGraph:fetchRequest];
    return fetchRequest;
}


- (NSFetchRequest *) graphExpensesFetchRequest
{
    NSFetchRequest *fetchRequest = [self graphFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0"]];
    [self configureFetchRequestForGraph:fetchRequest];
    return fetchRequest;
}



#pragma mark - Dealloc

- (void)dealloc
{
    // Remove notification observations
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
