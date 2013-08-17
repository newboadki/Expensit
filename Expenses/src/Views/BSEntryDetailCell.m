//
//  BSEntryDetailCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailCell.h"

@implementation BSEntryDetailCell

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
@end
