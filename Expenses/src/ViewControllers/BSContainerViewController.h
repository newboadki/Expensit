//
//  BSContainerViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 23/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainmentEventsAPI.h"

@class BSCoreDataController;

@interface BSContainerViewController : UIViewController <ContainmentEventsManager>

@property (nonatomic, strong, nullable) BSCoreDataController *coreDataController;


/// VIEWS
@property (nonatomic, weak, nullable) IBOutlet UIView *containerView;
@property (nonatomic, weak, nullable) IBOutlet UIView *chartContainer;
@property (nonatomic, weak, nullable) IBOutlet UIView *calendarContainer;

/// VERTICAL CONSTRAINTS
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *chartContainerHeightIsOneThirdOfSuperviewHeight;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *ChartContainerLeadingEqualsSuperviewLEading;// Fix it to the stackview's left

@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *calendarContainerTrailingEqualsSuperviewTrailing;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *calendarContainerHeightisTwoThirdsOfSuperviewsHeight;

// HORIZONTAL CONSTRAINTS
@property (nonatomic, strong, nullable) NSLayoutConstraint *chartContainerBottomEqualsSuperviewBottom;
@property (nonatomic, strong, nullable) NSLayoutConstraint *chartContainerWidthIsTwoThirdsOfSuperviewWidth;
@property (nonatomic, strong, nullable) NSLayoutConstraint *calendarContainerTopEqualsSuperviewTop;
@property (nonatomic, strong, nullable) NSLayoutConstraint *calendarContainerWidthIsOneThirdOfSuperviewsWidth;

// ALWAYS ACTIVE CONSTRAINTS
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *chartContainerTopEqualsSuperviewTop;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *chartContainerTrailingEqualsSuperviewTrailing;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *calendarContainerLeadingEqualsSuperviewLeading;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *calendarContainerBottomEqualsSuperviewBottom;


@end
