//
//  BSBaseExpensesSummaryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCoreDataController.h"
#import "BSCoreDataControllerDelegateProtocol.h"

@interface BSBaseExpensesSummaryViewController : UICollectionViewController <BSCoreDataControllerDelegateProtocol, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionViewLayout *layout;
@property (strong, nonatomic) BSCoreDataController *coreDataController;

/*! This is the date that the user wants to get entries from.*/
@property (strong, nonatomic) NSDate *queryDate;

@end
