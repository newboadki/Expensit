//
//  BSBaseExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpensesSummaryViewController.h"
#import "BSBaseExpenseCell.h"
#import "BSBaseExpensesSummaryViewController+Protected.h"
#import "BSEntryDetailsFormViewController.h"
#import "BSVisualEffects.h"
#import "BSModalSelectorViewTransitioningDelegate.h"
#import "BSAnimatedBlurEffectTransitioningDelegate.h"
#import "ContainmentEvent.h"
#import "BSStaticTableAddEntryFormCellActionDataSource.h"
#import "Expensit-Swift.h"


static BSExpenseCategory *tagBeingFilterBy = nil;


@interface BSBaseExpensesSummaryViewController ()
@property (nonatomic, strong) BSModalSelectorViewTransitioningDelegate *categoryFilterViewTransitioningDelegate;
@property (nonatomic, assign) BOOL visibleSenctionNameAlreadyCalculated;
@end



@implementation BSBaseExpensesSummaryViewController

#pragma mark - ContainmentEventHandler


/**
 As this view controller can be part of a more complex view hierarchy and contained without a container view controller,
 By conforming to this protocol, it gets the chance to react to certain UI events.

 @param event instance of a UI-related event.
 @param sender Source of the event.
 */
- (void)handleEvent:(ContainmentEvent *)event fromSender:(id<ContainmentEventSource>)sender {
    
}


#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstTimeViewWillAppear = YES;
    
    // NavBar buttons
    UIBarButtonItem *filterButton = self.navigationItem.rightBarButtonItems[1];
    
    // Request image for category filter
    [self.showEntriesPresenter viewIsReadyToDisplayImageForCategory:nil];
    
    UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItems[0];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];
    
    // Category filter view controller transitioning delegate
    self.categoryFilterViewTransitioningDelegate = [[BSModalSelectorViewTransitioningDelegate alloc] init];
    self.animatedBlurEffectTransitioningDelegate = [[BSAnimatedBlurEffectTransitioningDelegate alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /// We are doing this here beucase we want child view controllers to adapt to a new size.
    /// Now, we are also overriding viewWillTransitionToSize:withTransitionCoordinator: and invalidating the layout too.
    /// but there are some scenarios: landscape, yearly VC presented, then navigate to the monthly summary VC, it turns out that
    /// when the MonthlyLayout layout class gets called the bounds of the ViewController is still landscape.
    /// After viewWillAppear, bounds are correct and we need to recalculate the Monthly layout. There should be a better way.
    [self.collectionViewLayout invalidateLayout];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Request data
    [self.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        self.sections = sections;
        [self.collectionView reloadData];
        
        // Apply filter before calculating section to go to
        [self filterChangedToCategory:tagBeingFilterBy takingScreenshot:NO];
        
        // Scroll to selected section
        [self scrollToSelectedSection];
        
        // Let know interested parties that a section is visible. This is being used in certain trait collections
        // to update other view, like a chart that represents the data contained in the visible section.
        ContainmentEvent *event = [[ContainmentEvent alloc] initWithType:ChildControlledContentChanged userInfo:@{@"SectionName": [self visibleSectionName], @"SummaryType" : @(self.summaryType) }];
        [self.containmentEventsDelegate raiseEvent:event fromSender:self];
    }];
}


- (void)scrollToSelectedSection
{
    if (self.shouldScrollToSelectedSection && self.firstTimeViewWillAppear)
    {
        // Determine the index path
        self.firstTimeViewWillAppear = NO;
        NSArray *sectionNames = [self.sections valueForKeyPath:@"title"];
        NSMutableArray* uniqueSectionNames = [[NSMutableArray alloc] init];
        for(id sectionName in sectionNames)
        {
            if(![uniqueSectionNames containsObject:sectionName])
            {
                [uniqueSectionNames addObject:[NSString stringWithFormat:@"%@", sectionName]];
            }
        }
        NSArray *filteredArray = [uniqueSectionNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self = %@", self.nameOfSectionToBeShown]];
        NSInteger sectionToScrollTo = [uniqueSectionNames indexOfObject:[filteredArray lastObject]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionToScrollTo];

        ///TODO: layoutIfNeeded is not needed on iPhone. On iPad, these two lines make the scrolling be close to what it should be.
        /// The reason for the bug is not known yet.
        [self.collectionView layoutIfNeeded];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        [self.collectionView layoutIfNeeded];

        // Scroll to the header
        UIView *header = (UIView *)[self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[self reuseIdentifierForHeader] forIndexPath:indexPath];
        CGPoint offset = self.collectionView.contentOffset;
        offset.y -= header.frame.size.height;
        self.collectionView.contentOffset = offset;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.visibleSenctionNameAlreadyCalculated) {
        // Template method to ask subclasses what the event is? Do we need this?
        ContainmentEvent *event = [[ContainmentEvent alloc] initWithType:ChildControlledContentChanged userInfo:@{@"SectionName": [self visibleSectionName], @"SummaryType" : @(self.summaryType) }];
        [self.containmentEventsDelegate raiseEvent:event fromSender:self];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate {
    
    // If it will decelerate, then do not calculate it, since the scrolling will continue due to incercia simulation.
    // So set flag to be recognised by
    self.visibleSenctionNameAlreadyCalculated = !willDecelerate;
    
    if (willDecelerate) {
        self.visibleSenctionNameAlreadyCalculated = NO;
    } else {
        self.visibleSenctionNameAlreadyCalculated = YES;
        // Template method to ask subclasses what the event is? Do we need this?
        ContainmentEvent *event = [[ContainmentEvent alloc] initWithType:ChildControlledContentChanged userInfo:@{@"SectionName": [self visibleSectionName], @"SummaryType" : @(self.summaryType)}];
        [self.containmentEventsDelegate raiseEvent:event fromSender:self];
    }
}



#pragma mark - NavBar button actions

- (void)addButtonTappedWithPresentationCompletedBlock:(void (^ __nullable)(void))completion
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"addEntryNavigationController"];
    
    [self.navigationTransitionManager configureAddEntryViewControllerWithNavigationController:navController];
}



#pragma mark - segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddEntryForm"])
    {
        [self.navigationTransitionManager configureAddEntryViewControllerWithSegue:segue];        
    }
    else if ([[segue identifier] isEqualToString:@"showFilter"])
    {
        [self.navigationTransitionManager configureCategoryFilterViewControllerWithSegue:segue
                                                    categoryFilterViewControllerDelegate:self
                                                                        tagBeingFilterBy:tagBeingFilterBy
                                                 categoryFilterViewTransitioningDelegate:self.categoryFilterViewTransitioningDelegate];
    }
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


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (NSString*) visibleSectionName
{
    //TODO: IN case of a TIE, choose the section with the newest date
    NSArray *visibleCells = [self.collectionView visibleCells];
    NSMutableDictionary *occurences = [NSMutableDictionary dictionary];
    for (UICollectionViewCell *cell in visibleCells)
    {
        NSNumber *sectionNumber = [NSNumber numberWithInteger:[self.collectionView indexPathForCell:cell].section];
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
    
    BSDisplayExpensesSummarySection *sectionInfo = nil;
    
    if ([self.sections count] > 0)
    {
        sectionInfo = self.sections[sectionWithMostVisibleCells.intValue];
    }

    return sectionInfo.title;
}


- (NSString*) reuseIdentifierForHeader
{
    @throw @"Implement in subclasses";
}


- (BOOL) shouldScrollToSelectedSection
{
    return YES;
}



#pragma mark - BSCategoryFilterDelegate

- (void)filterChangedToCategory:(BSExpenseCategory *)tag
{
    [self filterChangedToCategory:tag takingScreenshot:YES];
}


- (void)filterChangedToCategory:(BSExpenseCategory *)tag takingScreenshot:(BOOL)shouldTakeScreenshot
{
    // So we remember when bringing the modal view back again
    // The argument is already a Tag* reference or nil
    tagBeingFilterBy = tag;
    
    // Change buttons
    UIBarButtonItem *filterButton = self.navigationItem.rightBarButtonItems[1];
    [self.showEntriesPresenter viewIsReadyToDisplayImageForCategory:tag]; // notify filter need ne image

    UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItems[0];
    self.navigationItem.rightBarButtonItems = @[addButton, filterButton];

    // Notify that flilter changed
    [self.showEntriesPresenter filterChangedToCategory:tag]; // this could be unified with previous
    
    [self.showEntriesPresenter viewIsReadyToDisplayEntriesCompletionBlock:^( NSArray * _Nullable sections) {
        
        self.sections = sections;
        [self.collectionView reloadData];
        
        if (shouldTakeScreenshot)
        {
            // Refresh blurry background after collectionview reloaded
            [self performSelector:@selector(blurrContentViewBackground) withObject:nil afterDelay:0.1];
        }
    }];
}



#pragma mark - Filter icons

- (void)blurrContentViewBackground
{
    // Do your stuff here. This will method will get called once your collection view get loaded.
   UIImage *image = [BSVisualEffects blurredViewImageFromView:self.view];

    UIViewController *presentedController = self.presentedViewController;
    UIView *contentView = [presentedController.view viewWithTag:100];
    
    UIImageView *imageView = (UIImageView *)[contentView viewWithTag:400];
    imageView.image = image;

    UIView *blurrContainer = [contentView viewWithTag:777];
    CGRect  rect = blurrContainer.bounds;
    rect.origin.x += 0;
    rect.origin.y += 0;
    blurrContainer.bounds = rect;
}



#pragma mark - BSAbstractExpensesSummaryUserInterfaceProtocol

- (void)displayCategoryImage:(UIImage *)image
{
    UIBarButtonItem *filterButton = self.navigationItem.rightBarButtonItems[1];
    [filterButton setImage:image];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    /// We do this to let collection views re-calculate their layout as it is done programmatically in layout classes,
    /// since we wanted the number of cells and rows to be constant to make it look like a regular calendar.
    [self.collectionViewLayout invalidateLayout];
}




@end

