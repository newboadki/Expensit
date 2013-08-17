//
//  BSEntrySegmentedOptionCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntrySegmentedOptionCell.h"
#import "BSConstants.h"
#import "BSAppDelegate.h"

@implementation BSEntrySegmentedOptionCell

@synthesize entryModel = _entryModel;

- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl
{
    // Change the UI
    switch (typeSegmentedControl.selectedSegmentIndex)
    {
        case EXPENSES_SEGMENTED_INDEX:
            typeSegmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
            break;
        case BENEFITS_SEGMENTED_INDEX:
            typeSegmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor];
            break;
            
        default:
            break;
    }
    
    // Let delegate know
    [self.delegate cell:self changedValue:[NSNumber numberWithInt:typeSegmentedControl.selectedSegmentIndex]];
}


- (void) setEntryModel:(Entry *)entryModel
{
    if (_entryModel != entryModel)
    {
        _entryModel = entryModel;
        
        switch ([_entryModel.value compare:@0])
        {
            case NSOrderedSame:
            case NSOrderedAscending:
                // NEGATIVE OR ZERO (yes, making 0 red, because when a new model is created the value is 0 and I want the default value of the segmented control be EXPENSES)
                self.entryTypeSegmentedControl.selectedSegmentIndex = EXPENSES_SEGMENTED_INDEX;
                self.entryTypeSegmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
                break;
            case NSOrderedDescending:
                // POSITIVE
                self.entryTypeSegmentedControl.selectedSegmentIndex = BENEFITS_SEGMENTED_INDEX;
                self.entryTypeSegmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor];
                break;
                
            default:
                break;
        }
    }
}


- (NSInteger) selectedIndex
{
    return self.entryTypeSegmentedControl.selectedSegmentIndex;
}


- (void) reset
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)self.control;
    segmentedControl.selectedSegmentIndex = EXPENSES_SEGMENTED_INDEX;
    self.entryTypeSegmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
    
}


@end
