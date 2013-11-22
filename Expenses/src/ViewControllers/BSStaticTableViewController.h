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
#import "BSStaticTableViewCell.h"
#import "BSStaticTableViewCellActionDataSourceProtocol.h"

@interface BSStaticTableViewController : UITableViewController <UITextFieldDelegate, BSStaticTableViewCellDelegateProtocol>

@property (strong, nonatomic) BSCoreDataController *coreDataController;
@property (assign, nonatomic) BOOL isEditingEntry;
@property (strong, nonatomic) Entry *entryModel;
@property (strong, nonatomic) id<BSStaticTableViewCellActionDataSourceProtocol> cellActionDataSource;


- (IBAction) addEntryPressed:(id)sender;
- (IBAction) cancelButtonPressed:(id)sender;

@end
