//
//  BSEntryDetailCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@protocol EntryDetailCellDelegateProtocol <NSObject>
- (void) cell:(UITableViewCell *)cell changedValue:(id)newValue;
- (void) textFieldShouldreturn;
@end

@interface BSEntryDetailCell : UITableViewCell

@property (strong, nonatomic) Entry *entryModel;
@property (strong, nonatomic) NSString *modelProperty;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIControl *control;
@property (strong, nonatomic) IBOutlet id<EntryDetailCellDelegateProtocol> delegate;

- (void) becomeFirstResponder;
- (void) resignFirstResponder;
- (void) reset;
@end
