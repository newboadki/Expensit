//
//  BSAddEntryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAddEntryViewController.h"

static const NSInteger EXPENSES_SEGMENTED_INDEX = 0;
static const NSInteger BENEFITS_SEGMENTED_INDEX = 1;

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


- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl
{
    switch (typeSegmentedControl.selectedSegmentIndex) {
        case EXPENSES_SEGMENTED_INDEX:
            self.entryTypeSymbolLabel.text = @"-";
            typeSegmentedControl.tintColor = [UIColor colorWithRed:199.0/255.0 green:43.0/255.0 blue:49.0/255.0 alpha:1.0];
            break;
        case BENEFITS_SEGMENTED_INDEX:
            self.entryTypeSymbolLabel.text = @"+";
            typeSegmentedControl.tintColor = [UIColor colorWithRed:86.0/255.0 green:130.0/255.0 blue:61.0/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
