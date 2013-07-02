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

@end
