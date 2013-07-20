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
    self.edgesForExtendedLayout = UIRectEdgeAll;

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fetchedResultsController performFetch:nil];
    [self.collectionView reloadData];

    if (self.shouldScrollToSelectedSection)
    {
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
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionToScrollTo] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
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
    return fetchRequest;
}


- (NSFetchRequest *) graphExpensesFetchRequest
{
    NSFetchRequest *fetchRequest = [self graphFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"value < 0"]];
    return fetchRequest;
}



#pragma mark - Dealloc

- (void)dealloc
{
    // Remove notification observations
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
