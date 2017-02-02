//
//  BSContainerViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 23/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import "BSContainerViewController.h"
#import "BSCoreDataController.h"
#import "BSYearlyExpensesSummaryViewController.h"
#import "BSGraphViewController.h"
#import "ExpensesSummaryType.h"
#import "Expensit-Swift.h"

@interface BSContainerViewController ()

@property (nonatomic, strong, nullable) BSYearlyExpensesSummaryViewController *yearlyViewController;
@property (nonatomic, strong, nullable) BSGraphViewController *graphViewController;
@property (nonatomic) BOOL landscapeAlreadyPresented;
@property (nonatomic, strong) BSYearlySummaryNavigationTransitionManager *yearlyTransitionManager;
@property (nonatomic, strong) BSMonthlySummaryNavigationTransitionManager *monthlyTransitionManager;
@property (nonatomic, strong) BSDailySummaryNavigationTransitionManager *dailyTransitionManager;
@end

@implementation BSContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    self.yearlyTransitionManager = [[BSYearlySummaryNavigationTransitionManager alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper
//                                                                                                coreDataController:self.coreDataController];
//    self.monthlyTransitionManager = [[BSMonthlySummaryNavigationTransitionManager alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper
//                                                                                                coreDataController:self.coreDataController];
//    self.dailyTransitionManager = [[BSDailySummaryNavigationTransitionManager alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper
//                                                                                                coreDataController:self.coreDataController];
    
    
    self.chartContainerBottomEqualsSuperviewBottom = [NSLayoutConstraint constraintWithItem: self.chartContainer
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                  relatedBy: NSLayoutRelationEqual
                                                                                     toItem: self.containerView
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                 multiplier: 1
                                                                                   constant: 0];
    
    self.chartContainerWidthIsTwoThirdsOfSuperviewWidth = [NSLayoutConstraint constraintWithItem: self.chartContainer
                                                                                       attribute: NSLayoutAttributeWidth
                                                                                       relatedBy: NSLayoutRelationEqual
                                                                                          toItem: self.containerView
                                                                                       attribute: NSLayoutAttributeWidth
                                                                                      multiplier: 0.7
                                                                                        constant: 0];
    
    self.calendarContainerWidthIsOneThirdOfSuperviewsWidth = [NSLayoutConstraint constraintWithItem: self.calendarContainer
                                                                                attribute: NSLayoutAttributeWidth
                                                                                relatedBy: NSLayoutRelationEqual
                                                                                toItem: self.containerView
                                                                                attribute: NSLayoutAttributeWidth
                                                                                multiplier: 0.3
                                                                                  constant: 0];
    
    self.calendarContainerTopEqualsSuperviewTop = [NSLayoutConstraint constraintWithItem: self.calendarContainer
                                                                               attribute: NSLayoutAttributeTop
                                                                               relatedBy: NSLayoutRelationEqual
                                                                                  toItem: self.containerView
                                                                               attribute: NSLayoutAttributeTop
                                                                              multiplier: 1
                                                                                constant: 0];
}


- (void) viewWillLayoutSubviews {
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        
        CGSize size = self.view.bounds.size;
        
        if (size.width >= size.height) {
            
            self.landscapeAlreadyPresented = YES;
            
            // Disable the constraints for the Chart container view to be placed vertically in the stackView
            if(self.chartContainerHeightIsOneThirdOfSuperviewHeight.isActive) {
                [NSLayoutConstraint deactivateConstraints:@[self.chartContainerHeightIsOneThirdOfSuperviewHeight,
                                                            self.ChartContainerLeadingEqualsSuperviewLEading,
                                                            self.calendarContainerTrailingEqualsSuperviewTrailing,
                                                            self.calendarContainerHeightisTwoThirdsOfSuperviewsHeight]];
            }
            
            // Add new constraints for the chart to be correcly placed horizontally in the stackView
            if (!self.chartContainerBottomEqualsSuperviewBottom.isActive) {
                [NSLayoutConstraint activateConstraints:@[self.chartContainerBottomEqualsSuperviewBottom,
                                                          self.chartContainerWidthIsTwoThirdsOfSuperviewWidth,
                                                          self.calendarContainerTopEqualsSuperviewTop,
                                                          self.calendarContainerWidthIsOneThirdOfSuperviewsWidth]];
            }
            
        } else {
            
            if (self.landscapeAlreadyPresented) {
                if (self.chartContainerBottomEqualsSuperviewBottom.isActive) {
                    [NSLayoutConstraint deactivateConstraints:@[self.chartContainerBottomEqualsSuperviewBottom,
                                                              self.chartContainerWidthIsTwoThirdsOfSuperviewWidth,
                                                              self.calendarContainerTopEqualsSuperviewTop,
                                                              self.calendarContainerWidthIsOneThirdOfSuperviewsWidth]];
                }
                
                if (!self.chartContainerHeightIsOneThirdOfSuperviewHeight.isActive) {
                    [NSLayoutConstraint activateConstraints:@[self.chartContainerHeightIsOneThirdOfSuperviewHeight,
                                                              self.chartContainerTopEqualsSuperviewTop,
                                                              self.ChartContainerLeadingEqualsSuperviewLEading,
                                                              self.calendarContainerTrailingEqualsSuperviewTrailing,
                                                              self.calendarContainerHeightisTwoThirdsOfSuperviewsHeight]];
                }

            }
        }
    }    
    [super viewWillLayoutSubviews];
}


- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    if([childController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationViewController = (UINavigationController *)childController;
        self.yearlyViewController = (BSYearlyExpensesSummaryViewController *)navigationViewController.topViewController;
        BSYearlySummaryNavigationTransitionManager *transitionManager = [[BSYearlySummaryNavigationTransitionManager alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper coreDataController:self.coreDataController containmentEventsDelegate:self];
        self.yearlyViewController.navigationTransitionManager = transitionManager;
        
        BSShowYearlyEntriesController * yearlyController = [[BSShowYearlyEntriesController alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper coreDataController:self.coreDataController];
        BSShowYearlyEntriesPresenter * yearlyPresenter = [[BSShowYearlyEntriesPresenter alloc] initWithShowEntriesUserInterface:self.yearlyViewController showEntriesController:yearlyController];
        self.yearlyViewController.showEntriesPresenter = yearlyPresenter;
        self.yearlyViewController.containmentEventsDelegate = self;
        
    } else if ([childController isKindOfClass:BSGraphViewController.class] ) {
        self.graphViewController = (BSGraphViewController *)childController;
        self.graphViewController.containmentEventsDelegate = self;
        
        id<BSGraphLineControllerProtocol>yearlyLineGraphController = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper coreDataController:self.coreDataController];
        id<BSGraphLinePresenterProtocol> yearlyLineGraphPresenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:yearlyLineGraphController section:@"2013"];
        self.graphViewController.lineGraphPresenter = yearlyLineGraphPresenter;
    }
}



#pragma mark - ContainmentEventsManager

- (void)raiseEvent:(ContainmentEvent *)event fromSender:(id<ContainmentEventSource>)sender {
    
    switch (event.type) {
        case ChildControlledContentChanged:
        {
            NSString *sectionName = (NSString *)event.userInfo[@"SectionName"];
            NSNumber *summaryTypeNumber = (NSNumber *)event.userInfo[@"SummaryType"];
            ExpensesSummaryType type = (ExpensesSummaryType)[summaryTypeNumber intValue];
            
            switch (type) {

                case YearlyExpensesSummaryType: {
                    id<BSGraphLineControllerProtocol> yearlyLineGraphController = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper coreDataController:self.coreDataController];
                    id<BSGraphLinePresenterProtocol> yearlyLineGraphPresenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:yearlyLineGraphController section:sectionName];
                    self.graphViewController.lineGraphPresenter = yearlyLineGraphPresenter;
                    [self.graphViewController.view setNeedsDisplay];
                    break;
                }
                case MonthlyExpensesSummaryType: {
                    id<BSGraphLineControllerProtocol> monthlyLineGraphController = [[BSMonthlySummaryGraphLineController alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper coreDataController:self.coreDataController];
                    id<BSGraphLinePresenterProtocol> monthlyLineGraphPresenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:monthlyLineGraphController section:sectionName];
                    self.graphViewController.lineGraphPresenter = monthlyLineGraphPresenter;
                    [self.graphViewController.view setNeedsDisplay];
                    break;
                }
                case DailyExpensesSummaryType:
                {
                    id<BSGraphLineControllerProtocol> dailyLineGraphController = [[BSDailySummaryGraphLineController alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper coreDataController:self.coreDataController];
                    id<BSGraphLinePresenterProtocol> dailyLineGraphPresenter = [[BSDailySummaryGraphLinePresenter alloc] initWithDailySummaryGraphLineController:dailyLineGraphController section:sectionName];
                    self.graphViewController.lineGraphPresenter = dailyLineGraphPresenter;
                    [self.graphViewController.view setNeedsDisplay];
                    break;
                }
                case AllEntriesExpensesSummaryType:
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
}


@end
