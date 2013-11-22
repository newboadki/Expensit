//
//  BSEntryDetailSingleButtonCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 11/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailSingleButtonCell.h"
#import "BSStaticTableViewCellChangeOfValueEvent.h"

@implementation BSEntryDetailSingleButtonCell

- (IBAction) deleteButtonPressed:(UIButton *)deleteButton
{
    BSStaticTableViewCellChangeOfValueEvent *event = [[BSStaticTableViewCellChangeOfValueEvent alloc] initWithNewValue:self.entryModel forPropertyName:@"deleteEntry"];
    event.indexPath = self.indexPath;

    [self.delegate cell:self eventOccurred:event];
}

- (void) configureWithCellInfo:(BSStaticTableViewCellInfo *)cellInfo andModel:(id)model
{
    self.entryModel = model;
}

@end
