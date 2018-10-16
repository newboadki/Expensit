//
//  BSBaseExpensesSummaryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAppDelegate.h"
#import "BSCategoryFilterDelegate.h"
#import "ContainmentEventsAPI.h"


/** Forward declarations */
@class BSBaseNavigationTransitionManager;
@protocol BSAbstractExpensesSummaryUserInterfaceProtocol;
@protocol BSAbstractExpensesSummaryPresenterEventsProtocol;
@protocol BSAbstractShowEntriesControllerProtocol;


/**
 Classes conforming to this protocol can handle the user intent to add a new entry.
 */
@protocol BSUIViewControllerAbilityToAddEntry <NSObject>
- (void)addButtonTappedWithPresentationCompletedBlock:(void (^ __nullable)(void))completion ;
@end



/**
 Abstract view controller that is responsible for presenting a 
 collection of entries grouped in sections.
 
 Subclasses are responsible for specifying the type of entries displayed
 and the type of grouping.
 */
@interface BSBaseExpensesSummaryViewController : UICollectionViewController <UICollectionViewDataSource,
                                                            UICollectionViewDelegate,
                                                            NSFetchedResultsControllerDelegate,
                                                            UICollectionViewDelegateFlowLayout,
                                                            BSCategoryFilterDelegate,
                                                            BSUIViewControllerAbilityToAddEntry,
                                                            BSAbstractExpensesSummaryUserInterfaceProtocol,
                                                            ContainmentEventHandler,
                                                            ContainmentEventSource>
/**
 Each summary screen retrieves data from the system from a presenter.
 Each summary screen communicates events to the sytem through a presenter.
 Subclasses can specialize the presenter.
 */
@property (strong, nonatomic, nullable) id<BSAbstractExpensesSummaryPresenterEventsProtocol> showEntriesPresenter;

/**
 A transition manager contains the knwoledge of how the UI should change according to different events.
 This way the VC is decoupled from the knowledge of which other VC should follow it or be presented after it.
 */
@property (strong, nonatomic, nullable) BSBaseNavigationTransitionManager *navigationTransitionManager;

/*! When the user is in a particular summary screen and selects a cell, this property is set by
 the previous viewController and used by the nextViewController to scroll to the right section.
 This property exists because in certain screens we don't show all items, for example, we just show
 months that have entries in the daily summary screen.*/
@property (copy, nonatomic, nullable) NSString *nameOfSectionToBeShown;

/*!
 @disscusion When this viewController is inside a navigation controller or another container, it can dissapear and appear again.
 */
@property (assign, nonatomic) BOOL firstTimeViewWillAppear;


/**
 Delegate object that receives UI events and it will propagate it to a set of interested parties.
 */
@property (nonatomic, nullable) id<ContainmentEventsManager> containmentEventsDelegate;

/*!
 @disscusion This is mainly used to calculate which section to take into consideration to calculate the data to feed a chart in landscape.
 @returns the name of the section that is predominantely visible, the one that occupies the most space.
 */
- (nullable NSString *) visibleSectionName;


@end
