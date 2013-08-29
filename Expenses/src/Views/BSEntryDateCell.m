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


@interface BSEntryDateCell ()
@property (assign, nonatomic) BOOL isExpanded;
@end

@implementation BSEntryDateCell

@synthesize entryModel = _entryModel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Creating the picker here, because putting it in the nib file makes the modal load reaaaally slow.
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(0, 44, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.datePicker addTarget:self action:@selector(entryDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

- (void) entryDatePickerValueChanged:(UIDatePicker *)picker
{
    self.entryModel.date = self.datePicker.date;
    self.entryModel.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:self.entryModel.date]];
    self.entryModel.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:self.entryModel.date]];;
    self.entryModel.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:self.entryModel.date]];;
    self.entryModel.monthYear = [NSString stringWithFormat:@"%@/%@", [self.entryModel.month stringValue], [self.entryModel.year stringValue]];
    self.entryModel.dayMonthYear = [NSString stringWithFormat:@"%@/%@/%@", [self.entryModel.day stringValue], [self.entryModel.month stringValue], [self.entryModel.year stringValue]];
    
    UIButton *button = (UIButton *)self.control;
    [button setTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:self.entryModel.date] forState:UIControlStateNormal];
}


- (IBAction) dateButtonPressed:(id)sender
{
    self.isExpanded = !self.isExpanded;
    UIButton *button = (UIButton *)self.control;
    if (self.isExpanded)
    {
        [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor] forState:UIControlStateNormal];
    }
    else
    {
        [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme blueColor] forState:UIControlStateNormal];
    }
    
    // tell the delegate that the button has been pressed
    if (!self.datePicker.superview) {
        [self addSubview:self.datePicker];
    }

    [self.delegate cell:self changedValue:nil];
}


- (void) setEntryModel:(Entry *)entryModel
{
    if (_entryModel != entryModel)
    {
        _entryModel = entryModel;
        UIButton *button = (UIButton *)self.control;
        NSDate *date = [self.entryModel valueForKey:self.modelProperty];
        if (date)
        {
            [button setTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:date] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:[NSDate date]] forState:UIControlStateNormal];

        }
    }
}

- (void) reset
{
    UIButton *button = (UIButton *)self.control;
    [button setTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:[NSDate date]] forState:UIControlStateNormal];
    
}


@end
