//
//  BSEntryTextDetail.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCell.h"

@interface BSEntryTextDetail : BSStaticTableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *entryTypeSymbolLabel; // not used at the moment
@property (assign, nonatomic) UIKeyboardType keyboardType;

- (IBAction) textFieldChanged:(UITextField *)textField;
- (void) displayPlusSign;
- (void) displayMinusSign;

@end