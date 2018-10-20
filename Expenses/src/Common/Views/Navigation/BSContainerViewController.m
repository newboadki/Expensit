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

@property (nonatomic, strong, nullable) UINavigationController *navController;
@property (nonatomic, strong, nullable) BSYearlyExpensesSummaryViewController *yearlyViewController;
@property (nonatomic, strong, nullable) BSGraphViewController *graphViewController;
@property (nonatomic) BOOL landscapeAlreadyPresented;
@property (nonatomic, strong) BSYearlySummaryNavigationTransitionManager *yearlyTransitionManager;
@property (nonatomic, strong) BSMonthlySummaryNavigationTransitionManager *monthlyTransitionManager;
@property (nonatomic, strong) BSDailySummaryNavigationTransitionManager *dailyTransitionManager;
@property (nonatomic, assign) BOOL shouldHandleEvents;

@property (nonatomic, nullable, copy) NSString *lastSectionName;
@property (nonatomic, assign) ExpensesSummaryType lastSummaryType;
@end

@implementation BSContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        self.shouldHandleEvents = YES;
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
    
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) || (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
                                                                                        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) ) {
        // This means (as defined in the StoryBoard) that we are going to present the line chart, therefore we need to determine the presenter.
        // And this is challenging, becuase the does not now, it will need to ask the calendar viewController, through a protocol, what's the type of graph and what is the section name?
        // Only then we'll be able to reuse the code in raiseEvent:switch (event.type) {
        
        
        NSLog(@"-> Name: %@, Type: %lu", self.lastSectionName, (unsigned long)self.lastSummaryType);
        
        switch (self.lastSummaryType) {
                
            case YearlyExpensesSummaryType: {
                id<BSGraphLineControllerProtocol> yearlyLineGraphController = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
                id<BSGraphLinePresenterProtocol> yearlyLineGraphPresenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:yearlyLineGraphController section:self.lastSectionName];
                self.graphViewController.lineGraphPresenter = yearlyLineGraphPresenter;
                [self.graphViewController.view setNeedsDisplay];
                break;
            }
            case MonthlyExpensesSummaryType: {
                id<BSGraphLineControllerProtocol> monthlyLineGraphController = [[BSMonthlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
                id<BSGraphLinePresenterProtocol> monthlyLineGraphPresenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:monthlyLineGraphController section:self.lastSectionName];
                self.graphViewController.lineGraphPresenter = monthlyLineGraphPresenter;
                [self.graphViewController.view setNeedsDisplay];
                break;
            }
            case DailyExpensesSummaryType:
            {
                id<BSGraphLineControllerProtocol> dailyLineGraphController = [[BSDailySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
                id<BSGraphLinePresenterProtocol> dailyLineGraphPresenter = [[BSDailySummaryGraphLinePresenter alloc] initWithDailySummaryGraphLineController:dailyLineGraphController section:self.lastSectionName];
                self.graphViewController.lineGraphPresenter = dailyLineGraphPresenter;
                [self.graphViewController.view setNeedsDisplay];
                break;
            }
            case AllEntriesExpensesSummaryType:
                
                break;
                
            default:
                break;
        }

    }
    
    [super viewWillLayoutSubviews];
}


- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    if([childController isKindOfClass:UINavigationController.class]) {
        self.navController = (UINavigationController *)childController;
        self.yearlyViewController = (BSYearlyExpensesSummaryViewController *)self.navController.topViewController;
        BSYearlySummaryNavigationTransitionManager *transitionManager = [[BSYearlySummaryNavigationTransitionManager alloc] initWithCoreDataStackHelper:self.coreDataController.coreDataHelper
                                                                                                                                     coreDataController:self.coreDataController
                                                                                                                                coreDataFetchController:self.coreDataFetchController
                                                                                                                              containmentEventsDelegate:self];
        self.yearlyViewController.navigationTransitionManager = transitionManager;
        
        BSShowYearlyEntriesController * yearlyController = [[BSShowYearlyEntriesController alloc] initWithDataProvider:self.coreDataFetchController];
        BSShowYearlyEntriesPresenter * yearlyPresenter = [[BSShowYearlyEntriesPresenter alloc] initWithShowEntriesUserInterface:self.yearlyViewController showEntriesController:yearlyController];
        self.yearlyViewController.showEntriesPresenter = yearlyPresenter;
        self.yearlyViewController.containmentEventsDelegate = self;
        
    } else if ([childController isKindOfClass:BSGraphViewController.class] ) {
        self.graphViewController = (BSGraphViewController *)childController;
        self.graphViewController.containmentEventsDelegate = self;
        
        id<BSGraphLineControllerProtocol>yearlyLineGraphController = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
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
            self.lastSectionName = sectionName;
            self.lastSummaryType = type;
            
            if (!self.shouldHandleEvents) {
                return;
            }

            
            switch (type) {

                case YearlyExpensesSummaryType: {
                    id<BSGraphLineControllerProtocol> yearlyLineGraphController = [[BSYearlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
                    id<BSGraphLinePresenterProtocol> yearlyLineGraphPresenter = [[BSYearlySummaryGraphLinePresenter alloc] initWithYearlySummaryGraphLineController:yearlyLineGraphController section:sectionName];
                    self.graphViewController.lineGraphPresenter = yearlyLineGraphPresenter;
                    [self.graphViewController.view setNeedsDisplay];
                    break;
                }
                case MonthlyExpensesSummaryType: {
                    id<BSGraphLineControllerProtocol> monthlyLineGraphController = [[BSMonthlySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
                    id<BSGraphLinePresenterProtocol> monthlyLineGraphPresenter = [[BSMonthlySummaryGraphLinePresenter alloc] initWithMonthlySummaryGraphLineController:monthlyLineGraphController section:sectionName];
                    self.graphViewController.lineGraphPresenter = monthlyLineGraphPresenter;
                    [self.graphViewController.view setNeedsDisplay];
                    break;
                }
                case DailyExpensesSummaryType:
                {
                    id<BSGraphLineControllerProtocol> dailyLineGraphController = [[BSDailySummaryGraphLineController alloc] initWithCoreDataFetchController:self.coreDataFetchController];
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
