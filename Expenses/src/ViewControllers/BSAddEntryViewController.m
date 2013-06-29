//
//  BSAddEntryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAddEntryViewController.h"

@interface BSAddEntryViewController ()

@end

@implementation BSAddEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.amountTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) addEntryPressed:(id)sender
{
    BSCoreDataController* coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataStackHelper];
    
    [coreDataController insertNewEntryWithDate:[NSDate date] description:self.descriptionTextField.text value:self.amountTextField.text];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
