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
#import "Entry.h"
#import "BSEntryDetailCell.h"


@interface BSEntryDetailsViewController : UITableViewController <UITextFieldDelegate, EntryDetailCellDelegateProtocol>

@property (strong, nonatomic) CoreDataStackHelper *coreDataStackHelper;
@property (assign, nonatomic) BOOL isEditingEntry;
@property (strong, nonatomic) Entry *entryModel;

- (IBAction) addEntryPressed:(id)sender;
- (IBAction) cancelButtonPressed:(id)sender;
@end
