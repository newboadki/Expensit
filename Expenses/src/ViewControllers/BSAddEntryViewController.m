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
    
    
    NSString *amount = self.amountTextField.text;
    if (self.entryTypeSwitch.on) {
        amount = [@"-" stringByAppendingString:amount];
    }
    
    [coreDataController insertNewEntryWithDate:[NSDate date] description:self.descriptionTextField.text value:amount];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction) typeSwitchChanged:(UISwitch*)typeSwitch
{
    if (typeSwitch.on) {
        self.entryTypeLabel.text = NSLocalizedString(@"Expense", @"");
        self.entryTypeSymbolLabel.text = @"-";

    } else {    
        self.entryTypeLabel.text = NSLocalizedString(@"Positive Entry", @"");
        self.entryTypeSymbolLabel.text = @"+";
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
