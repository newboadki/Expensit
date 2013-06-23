//
//  BSBaseExpensesSummaryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSBaseExpensesSummaryViewController.h"
#import "BSAppDelegate.h"

@interface BSBaseExpensesSummaryViewController ()

@end

@implementation BSBaseExpensesSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BSAppDelegate *delegate = (BSAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry"
                                                                      delegate:self
                                                                coreDataHelper:delegate.coreDataHelper];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDelegate

#pragma mark - BSCoreDataControllerDelegate

- (void) configureFetchRequest:(NSFetchRequest*)fetchRequest {
    // Batch Size
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
}


- (NSString*) sectionNameKeyPath
{
    @throw @"Implement in subclasses";
    return nil;
}




@end
