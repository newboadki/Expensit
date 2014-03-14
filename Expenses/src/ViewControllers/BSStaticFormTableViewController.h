//
//  BSAddEntryViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BSCells.h"
#import "../Protocols/BSStaticFormTableViewCellActionDataSourceProtocol.h"
#import "../Protocols/BSStaticTableViewCellDelegateProtocol.h"

@interface BSStaticFormTableViewController : UITableViewController <BSStaticTableViewCellDelegateProtocol>

@property (assign, nonatomic) BOOL isEditingEntry;
@property (strong, nonatomic) id entryModel;
@property (strong, nonatomic) id<BSStaticFormTableViewCellActionDataSourceProtocol> cellActionDataSource;


- (IBAction) addEntryPressed:(id)sender;
- (IBAction) cancelButtonPressed:(id)sender;

@end
