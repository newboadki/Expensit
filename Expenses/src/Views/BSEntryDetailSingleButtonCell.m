//
//  BSEntryDetailSingleButtonCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 11/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailSingleButtonCell.h"

@implementation BSEntryDetailSingleButtonCell

- (IBAction) deleteButtonPressed:(UIButton *)deleteButton
{
    [self.delegate cell:self changedValue:nil];
}

@end
