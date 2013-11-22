//
//  BSEntrySegmentedOptionCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCell.h"

@interface BSEntrySegmentedOptionCell : BSStaticTableViewCell

@property (nonatomic, strong) NSMutableArray *colorsForSegments;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl;

- (NSInteger) selectedIndex;

- (void) setOptions:(NSArray *)options;

@end
