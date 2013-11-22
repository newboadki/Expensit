//
//  BSEntryDetailCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCell.h"

@implementation BSStaticTableViewCell


- (void) becomeFirstResponder
{
    [super becomeFirstResponder];
    [self.control becomeFirstResponder];
    
}


- (void) resignFirstResponder
{
    [super resignFirstResponder];
    [self.control resignFirstResponder];
}


- (void) reset
{

}


- (void) configureWithCellInfo:(BSStaticTableViewCellInfo *)cellInfo andModel:(id)model
{
    @throw [NSException exceptionWithName:@"Abstract method" reason:@"Implement in subclasses" userInfo:nil];
}


- (void)updateValuesFromModel
{

}

@end
