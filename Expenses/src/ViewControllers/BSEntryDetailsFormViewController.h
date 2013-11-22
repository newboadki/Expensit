//
//  BSEntryDetailsFormViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 20/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewController.h"

@class BSCoreDataController;

@interface BSEntryDetailsFormViewController : BSStaticTableViewController

@property (strong, nonatomic) BSCoreDataController *coreDataController;

@end
