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
#import "BSStaticTableViewCellChangeOfValueEvent.h"

@implementation BSEntrySegmentedOptionCell

@synthesize entryModel = _entryModel;
@synthesize label = _label;
@synthesize control = _control;

- (void) setOptions:(NSArray *)options
{
    
    if (!options || [options count]==0)
    {
        return;
    }

    [self.segmentedControl removeAllSegments];
    
    int i= 0;
    for (NSString *title in options)
    {
        [self.segmentedControl insertSegmentWithTitle:title atIndex:i++ animated:NO];
    }
    
    [self.segmentedControl setNeedsDisplay];
        
}

- (void) configureWithCellInfo:(BSStaticTableViewCellInfo *)cellInfo andModel:(id)model
{
    self.label.text = cellInfo.displayPropertyName;
    self.modelProperty = cellInfo.propertyName;
    self.entryModel = model;

    [self setOptions:cellInfo.extraParams[@"options"]];
    [self setColorsForSegments:cellInfo.extraParams[@"colors"]];

    [self.control setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.control setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_label, _control);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_label]-(>=30)-[_control]-20-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewDictionary];
    NSArray *verticalConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_label]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_label)];
    NSArray *verticalConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_control]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_control)];
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints1];
    [self addConstraints:verticalConstraints2];
}

- (IBAction) entryTypeSegmenteControlChanged:(UISegmentedControl*)typeSegmentedControl
{
    NSInteger selectedIndex = typeSegmentedControl.selectedSegmentIndex;
    
    // Change the UI
    if ((selectedIndex >= 0) && (selectedIndex < [self.colorsForSegments count]))
    {
        typeSegmentedControl.tintColor = self.colorsForSegments[selectedIndex];
    }
    else
    {
        typeSegmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme grayColor]; // Default
    }
    
    // Change the model
    if (self.valueConvertor)
    {
        [self.entryModel setValue:[self.valueConvertor modelValueForCellValue:@(self.selectedIndex)] forKey:self.modelProperty];
    }
    else
    {
        [self.entryModel setValue:@(selectedIndex) forKey:self.modelProperty];
    }

    
    // Let delegate know
    BSStaticTableViewCellChangeOfValueEvent *event = [[BSStaticTableViewCellChangeOfValueEvent alloc] initWithNewValue:[self.entryModel valueForKey:self.modelProperty] forPropertyName:self.modelProperty];
    event.indexPath = self.indexPath;
    [self.delegate cell:self eventOccurred:event];
}


- (NSInteger) selectedIndex
{
    return self.segmentedControl.selectedSegmentIndex;
}


- (void) reset
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)self.control;
    segmentedControl.selectedSegmentIndex = EXPENSES_SEGMENTED_INDEX;
    self.segmentedControl.tintColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
    
}


- (void)updateValuesFromModel
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)self.control;
    
    if (self.valueConvertor)
    {
        segmentedControl.selectedSegmentIndex = [[self.valueConvertor cellValueForModelValue:[self.entryModel valueForKey:self.modelProperty]] intValue];
    }
    else
    {
        segmentedControl.selectedSegmentIndex = [[self.entryModel valueForKey:self.modelProperty] intValue];
    }
    
    
    
    // Tint Color
    self.segmentedControl.tintColor = self.colorsForSegments[segmentedControl.selectedSegmentIndex];
    
    // Let delegate know
    BSStaticTableViewCellChangeOfValueEvent *event = [[BSStaticTableViewCellChangeOfValueEvent alloc] initWithNewValue:[self.entryModel valueForKey:self.modelProperty] forPropertyName:self.modelProperty];
    event.indexPath = self.indexPath;
    [self.delegate cell:self eventOccurred:event];
}


@end
