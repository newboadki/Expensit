//
//  BSGraphViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 09/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSGraphViewController.h"
#import "BSCurrencyHelper.h"
#import "ContainmentEvent.h"
#import "Expensit-Swift.h"

@interface BSGraphViewController ()

@end

@implementation BSGraphViewController

- (void)setLineGraphPresenter:(id<BSGraphLinePresenterProtocol>)lineGraphPresenter {

    /// TODO: Take care of more things
    _lineGraphPresenter = lineGraphPresenter;
    
    
    /// Having to do this here instead of viewDidLoad, becuase the container that loads it sets these values in its addChildViewController override: but the vcs's viewDidload have already been called. Therefore by the time it is settings the values, viewDidload of this class has already been called.
    
    /// EDIT: Take this out of view-cycle-related methods and create a public method to be called by the container or whoever at the right time (after the presenter has ben set but before it is visible)

    self.graphTitle = [_lineGraphPresenter graphTitle];
    self.moneyIn = [_lineGraphPresenter income];
    self.moneyOut = [_lineGraphPresenter expenses];
    self.xValues = [_lineGraphPresenter abscissaValues];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}



#pragma mark - LineGraphCurrencyFormatterProtocol

- (NSString *) formattedStringForNumber:(NSNumber *)number
{
    return [[BSCurrencyHelper amountFormatter] stringFromNumber:number];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    /// We do this to let collection views re-calculate their layout as it is done programmatically in layout classes,
    /// since we wanted the number of cells and rows to be constant to make it look like a regular calendar.
    [self.view setNeedsDisplay];
}



#pragma mark - ContainmentEventHandler

- (void)handleEvent:(ContainmentEvent *)event fromSender:(id<ContainmentEventSource>)sender
{
    
}

@end
