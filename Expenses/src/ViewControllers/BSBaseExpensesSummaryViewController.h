//
//  BSBaseExpensesSummaryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCoreDataControllerDelegateProtocol.h"
#import "BSAppDelegate.h"
#import "BSCurrencyHelper.h"

@class CoreDataStackHelper;


@interface BSBaseExpensesSummaryViewController : UICollectionViewController <BSCoreDataControllerDelegateProtocol, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UICollectionViewLayout *layout;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;

/*! When the user is in a particular summary screen and selects a cell, this property is set by 
 the previous viewController and used by the nextViewController to scroll to the right section.*/
@property (strong, nonatomic) NSIndexPath *sectionToBeShownIndexPath;

/*! When the user is in a particular summary screen and selects a cell, this property is set by
 the previous viewController and used by the nextViewController to scroll to the right section.
 This property exists because in certain screens we don't show all items, for example, we just show
 months that have entries in the daily summary screen.*/
@property (strong, nonatomic) NSString *nameOfSectionToBeShown;


@property (assign, nonatomic) BOOL shouldScrollToSelectedSection;

@end
