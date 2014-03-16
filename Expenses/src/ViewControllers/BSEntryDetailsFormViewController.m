//
//  BSEntryDetailsFormViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 20/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailsFormViewController.h"
#import "BSCoreDataController.h"
#import <QuartzCore/QuartzCore.h>
#import "BSAppDelegate.h"
#import "BSThemeManager.h"

@implementation BSEntryDetailsFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Nav Bar buttons
    BSThemeManager *manager =  ((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager;
    UIImage *imageGreen = [manager.theme stretchableImageForNavBarDecisionButtonsWithStrokeColor:[manager.theme greenColor] fillColor:nil];
    UIImage *imageRed = [manager.theme stretchableImageForNavBarDecisionButtonsWithStrokeColor:[manager.theme redColor] fillColor:nil];
    
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    [doneButton setBackgroundImage:imageGreen forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *cancelButton = self.navigationItem.leftBarButtonItem;
    [cancelButton setBackgroundImage:imageRed forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [manager.theme redColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
}

- (IBAction) addEntryPressed:(id)sender
{
    NSError *error = nil;
    if ([self saveModel:&error])
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't save" message:[error userInfo][NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction) cancelButtonPressed:(id)sender
{
    if (self.isEditingEntry)
    {
        [self.coreDataController discardChanges];
    }
    else
    {
        [self.coreDataController deleteModel:self.entryModel];
        [self.coreDataController saveChanges];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) saveModel:(NSError **)error
{
    return [self.coreDataController saveEntry:self.entryModel error:error];
}


#pragma mark - UITextFieldDelegate

/* TODO: Convert this method into a cell event*/
- (void) textFieldShouldreturn
{
    
    NSError *error = nil;
    if ([self saveModel:&error])
    {
        if (!self.isEditingEntry)
        {
            self.entryModel = [self.coreDataController newEntry];
            [self.tableView reloadData];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't save" message:[error userInfo][NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
