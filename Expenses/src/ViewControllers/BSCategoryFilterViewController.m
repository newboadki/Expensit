//
//  BSCategoryFilterViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSCategoryFilterViewController.h"
#import <QuartzCore/QuartzCore.h>


static NSString const * kNofilterText = @"No Filter"; // make it a localizable key

@interface BSCategoryFilterViewController ()

@end

@implementation BSCategoryFilterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *contentView = [self.view viewWithTag:100];
    
    [contentView.layer setCornerRadius:4];
    [contentView.layer setShadowColor:[UIColor blackColor].CGColor];
    [contentView.layer setShadowOpacity:0.3];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-5, 5, contentView.frame.size.width+10, contentView.frame.size.height+5) cornerRadius:2];
    [contentView.layer setShadowPath:path.CGPath];
    
    int index = [self.categories indexOfObject:self.selectedTag];
    if (index == NSNotFound)
    {
        index = 0;
    }
    
    [self.pickerView selectRow:index
                   inComponent:0
                      animated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view.window addGestureRecognizer:gr];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapped:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            // Remove the recognizer first so it's view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (void)setCategories:(NSArray *)categories
{
    if (_categories != categories)
    {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:categories];
        [temp insertObject:kNofilterText atIndex:0];
        _categories = [NSArray arrayWithArray:temp];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id element = self.categories[row];
    if ([element isKindOfClass:Tag.class])
    {
        Tag *tag = (Tag *)element;
        return [tag name];
    }
    else
    {
        return element;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)selectedRow inComponent:(NSInteger)component
{
    if (selectedRow == 0) // No filter
    {
        [self.delegate filterChangedToCategory:nil];
    }
    else
    {
        id element = self.categories[selectedRow];
        [self.delegate filterChangedToCategory:element];
    }
    
    self.statusLabel.text = @"Done";
    self.statusLabel.alpha = 0.0f;
    
    

    
    [UIView animateWithDuration:0.5 animations:^{
        self.statusLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:0 animations:^{
            self.statusLabel.alpha = 0.0f;
        } completion:nil];
    }];

}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.categories.count;
}

@end
