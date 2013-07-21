//
//  BSAddEntryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"

@interface BSAddEntryViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *entryTypeSwitch;
@property (strong, nonatomic) IBOutlet UILabel *entryTypeSymbolLabel;
@property (strong, nonatomic) IBOutlet UITableView *fieldsTableView;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;

- (IBAction) addEntryPressed:(id)sender;

- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl;

@end
