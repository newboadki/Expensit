//
//  BSEntryTextDetail.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailCell.h"

@interface BSEntryTextDetail : BSEntryDetailCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *entryTypeSymbolLabel;

- (IBAction) textFieldChanged:(UITextField *)textField;
- (void) displayPlusSign;
- (void) displayMinusSign;
@end
