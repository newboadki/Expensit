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
@property (assign, nonatomic) BOOL isPressed;
@end

@implementation BSEntryDateCell

@synthesize entryModel = _entryModel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    
    return self;
}

- (IBAction) dateButtonPressed:(id)sender
{
    self.isPressed = !self.isPressed;
    UIButton *button = (UIButton *)self.control;
    if (self.isPressed)
    {
        [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor] forState:UIControlStateNormal];
    }
    else
    {
        [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme blueColor] forState:UIControlStateNormal];
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

- (void) setDate:(NSString*)date {
    UIButton *button = (UIButton *)self.control;
    if (self.isPressed)
    {
        [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor] forState:UIControlStateNormal];
    }
    else
    {
        [button setTitleColor:[((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme blueColor] forState:UIControlStateNormal];
    }
    
    button.titleLabel.text = date;

}

- (void) reset
{
    UIButton *button = (UIButton *)self.control;
    [button setTitle:[DateTimeHelper dateStringWithFormat:[DEFAULT_DATE_FORMAT copy] date:[NSDate date]] forState:UIControlStateNormal];
    
}


@end
