//
//  BSEntryDateCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryDateCell.h"
#import "DateTimeHelper.h"
#import "BSAppDelegate.h"
#import "BSStaticTableViewCellFoldingEvent.h"
#import "BSStaticTableViewComponentConstants.h"

@interface BSEntryDateCell ()
@end

@implementation BSEntryDateCell

@synthesize entryModel = _entryModel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, self.bounds.size.height, _datePicker.bounds.size.width, _datePicker.bounds.size.height);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(entryDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_datePicker];
    }
    
    return self;
}


- (void) configureWithCellInfo:(BSStaticTableViewCellInfo *)cellInfo andModel:(id)model
{
    self.modelProperty = cellInfo.propertyName;
    self.label.text = NSLocalizedString(cellInfo.displayPropertyName, @"");
    self.entryModel = model;
}

- (void)updateValuesFromModel
{
    if (self.valueConvertor)
    {
        self.datePicker.date = [self.valueConvertor cellValueForModelValue:[self.entryModel valueForKey:self.modelProperty]];
    }
    else
    {
        NSDate *date = [self.entryModel valueForKey:self.modelProperty];
        if (!date)
        {
            date = [NSDate date];
        }
        
        self.datePicker.date = date;
        [self setDateInTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:date]];
    }
}



- (IBAction) entryDatePickerValueChanged:(UIDatePicker *)picker
{
    // Update the model
    if (self.valueConvertor)
    {
        [self.entryModel setValue:[self.valueConvertor modelValueForCellValue:picker.date] forKey:self.modelProperty];
    }
    else
    {
        [self.entryModel setValue:picker.date forKey:self.modelProperty];
    }

    // Update title in button
    [self setDateInTitle:[[self.entryModel valueForKeyPath:self.modelProperty] description]];
}


- (IBAction) dateButtonPressed:(id)sender
{
    // The view controller is the only one that could know the state of the cell
    // because cells are reused so their values are not reliable unless they get set by the view controller
    BSStaticTableViewCellFoldingEvent *event =[[BSStaticTableViewCellFoldingEvent alloc] init];
    event.indexPath = self.indexPath;
    [self.delegate cell:self eventOccurred:event];
}

- (void) setDate:(NSString*)date
{
    // Button Value
    [self setDateInTitle:date];
    
    // Picker value
    self.datePicker.date = [DateTimeHelper dateWithFormat:[DEFAULT_DATE_FORMAT copy] stringDate:date];
}


- (void)setDateInTitle:(NSString *)date
{
    UIButton *button = (UIButton *)self.control;
    [button setTitle:date forState:UIControlStateNormal];
    [button setTitle:date forState:UIControlStateHighlighted];
    [button setTitle:date forState:UIControlStateSelected];
}


- (void) reset
{
    UIButton *button = (UIButton *)self.control;
    [button setTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:[NSDate date]] forState:UIControlStateNormal];
    
}

#pragma mark - BSTableViewExpandableCell

- (void)setUpForFoldedState
{
    // Color of the button when not selected
    UIButton *button = (UIButton *)self.control;
    [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme blueColor] forState:UIControlStateNormal];


}


- (void)setUpForUnFoldedState
{
    // Color of the button when selected
    UIButton *button = (UIButton *)self.control;
    [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor] forState:UIControlStateNormal];
}


@end
