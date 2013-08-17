//
//  BSEntrySegmentedOptionCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDetailCell.h"

@interface BSEntrySegmentedOptionCell : BSEntryDetailCell

@property (strong, nonatomic) IBOutlet UISegmentedControl *entryTypeSegmentedControl;

- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl;
- (NSInteger) selectedIndex;

@end
