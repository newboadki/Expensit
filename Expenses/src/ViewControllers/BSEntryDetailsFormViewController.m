//
//  BSEntryDetailsFormViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 20/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailsFormViewController.h"
#import "BSCoreDataController.h"

@implementation BSEntryDetailsFormViewController

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
