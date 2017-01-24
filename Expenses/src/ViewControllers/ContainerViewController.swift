//
//  ViewController.swift
//  CustomAdaptiveApp
//
//  Created by Borja Arias Drake on 05/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import UIKit


class ContainerViewController : UIViewController {
        
    public var coreDataController : BSCoreDataController!
    var yearlyViewController : BSYearlyExpensesSummaryViewController!
    
    /// VIEWS
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var calendarContainer: UIView!
    
    /// VERTICAL CONSTRAINTS
    @IBOutlet weak var chartContainerHeightIsOneThirdOfSuperviewHeight: NSLayoutConstraint!
    @IBOutlet weak var ChartContainerLeadingEqualsSuperviewLEading: NSLayoutConstraint! // Fix it to the stackview's left
    
    @IBOutlet weak var calendarContainerTrailingEqualsSuperviewTrailing: NSLayoutConstraint!
    @IBOutlet weak var calendarContainerHeightisTwoThirdsOfSuperviewsHeight: NSLayoutConstraint!
    
    // HORIZONTAL CONSTRAINTS
    var chartContainerBottomEqualsSuperviewBottom: NSLayoutConstraint!
    var chartContainerWidthIsTwoThirdsOfSuperviewWidth: NSLayoutConstraint!
    var calendarContainerTopEqualsSuperviewTop: NSLayoutConstraint!
    var calendarContainerWidthIsOneThirdOfSuperviewsWidth: NSLayoutConstraint!
    
    // ALWAYS ACTIVE CONSTRAINTS
    @IBOutlet weak var chartContainerTopEqualsSuperviewTop: NSLayoutConstraint! // Fix it to the top of the stackview
    @IBOutlet weak var chartContainerTrailingEqualsSuperviewTrailing: NSLayoutConstraint! // Fix it to the stackview's right
    @IBOutlet weak var calendarContainerLeadingEqualsSuperviewLeading: NSLayoutConstraint!
    @IBOutlet weak var calendarContainerBottomEqualsSuperviewBottom: NSLayoutConstraint! // Fix it to the top of the stackview
    
    
    var landscapeAlreadyPresented = false
    
    /// METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare constraints for when layout needs to change
        self.chartContainerBottomEqualsSuperviewBottom = NSLayoutConstraint(item: self.chartContainer,
                                                                            attribute: .bottom,
                                                                            relatedBy: .equal,
                                                                            toItem: self.containerView,
                                                                            attribute: .bottom,
                                                                            multiplier: 1,
                                                                            constant: 0)
        
        self.chartContainerWidthIsTwoThirdsOfSuperviewWidth = NSLayoutConstraint(item: self.chartContainer,
                                                                                 attribute: .width,
                                                                                 relatedBy: .equal,
                                                                                 toItem: self.containerView,
                                                                                 attribute: .width,
                                                                                 multiplier: 0.7,
                                                                                 constant: 0)
        
        self.calendarContainerWidthIsOneThirdOfSuperviewsWidth = NSLayoutConstraint(item: self.calendarContainer,
                                                                                    attribute: .width,
                                                                                    relatedBy: .equal,
                                                                                    toItem: self.containerView,
                                                                                    attribute: .width,
                                                                                    multiplier: 0.3,
                                                                                    constant: 0)
        
        self.calendarContainerTopEqualsSuperviewTop = NSLayoutConstraint(item: self.calendarContainer,
                                                                         attribute: .top,
                                                                         relatedBy: .equal,
                                                                         toItem: self.containerView,
                                                                         attribute: .top,
                                                                         multiplier: 1,
                                                                         constant: 0)
    }
    
    override open func viewWillLayoutSubviews() {
        
        if self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .regular {
            let size = self.view.bounds.size
            if size.width >= size.height {
                self.landscapeAlreadyPresented = true
                
                // Disable the constraints for the Chart container view to be placed vertically in the stackView
                if self.chartContainerHeightIsOneThirdOfSuperviewHeight.isActive {
                    
                    NSLayoutConstraint.deactivate([self.chartContainerHeightIsOneThirdOfSuperviewHeight,
                                                   self.ChartContainerLeadingEqualsSuperviewLEading,
                                                   self.calendarContainerTrailingEqualsSuperviewTrailing,
                                                   self.calendarContainerHeightisTwoThirdsOfSuperviewsHeight
                        ])
                }
                
                // Add new constraints for the chart to be correcly placed horizontally in the stackView
                if !chartContainerBottomEqualsSuperviewBottom.isActive {
                    NSLayoutConstraint.activate([self.chartContainerBottomEqualsSuperviewBottom,
                                                 self.chartContainerWidthIsTwoThirdsOfSuperviewWidth,
                                                 self.calendarContainerTopEqualsSuperviewTop,
                                                 self.calendarContainerWidthIsOneThirdOfSuperviewsWidth])
                }
                
            } else {
                
                if self.landscapeAlreadyPresented {
                    // PORTRAIT
                    
                    // Disable the constraints for the Chart container view to be placed horizontally in the stackView
                    if self.chartContainerBottomEqualsSuperviewBottom.isActive {
                        
                        NSLayoutConstraint.deactivate([self.chartContainerBottomEqualsSuperviewBottom,
                                                       self.chartContainerWidthIsTwoThirdsOfSuperviewWidth,
                                                       self.calendarContainerTopEqualsSuperviewTop,
                                                       self.calendarContainerWidthIsOneThirdOfSuperviewsWidth])
                    }
                    
                    // Add new constraints for the chart to be correcly placed vertically in the stackView
                    if !self.chartContainerHeightIsOneThirdOfSuperviewHeight.isActive {
                        NSLayoutConstraint.activate([self.chartContainerHeightIsOneThirdOfSuperviewHeight,
                                                     self.chartContainerTopEqualsSuperviewTop,
                                                     ChartContainerLeadingEqualsSuperviewLEading,
                                                     self.calendarContainerTrailingEqualsSuperviewTrailing,
                                                     self.calendarContainerHeightisTwoThirdsOfSuperviewsHeight])
                    }
                }
            }
        }
        
        super.viewWillLayoutSubviews()
    }
    
    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        
        if childController is UINavigationController {
            let navigationViewController = childController as! UINavigationController
            yearlyViewController = navigationViewController.topViewController as! BSYearlyExpensesSummaryViewController
            let transitionManager = BSYearlySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataController.coreDataHelper, coreDataController: self.coreDataController)
            yearlyViewController.navigationTransitionManager = transitionManager
            let yearlyController = BSShowYearlyEntriesController(coreDataStackHelper: self.coreDataController.coreDataHelper, coreDataController: self.coreDataController)
            let yearlyPresenter = BSShowYearlyEntriesPresenter(showEntriesUserInterface: yearlyViewController, showEntriesController: yearlyController)
            
            yearlyViewController.showEntriesPresenter = yearlyPresenter
        } else if childController is BSGraphViewController {
            let graphViewController = childController as! BSGraphViewController
            graphViewController.containmentEventsDelegate = self;
            
            let yearlyLineGraphController : BSGraphLineControllerProtocol = BSYearlySummaryGraphLineController(coreDataStackHelper : self.coreDataController.coreDataHelper, coreDataController : self.coreDataController)
            let yearlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSYearlySummaryGraphLinePresenter(yearlySummaryGraphLineController: yearlyLineGraphController, section: "2013")
            graphViewController.lineGraphPresenter = yearlyLineGraphPresenter
            
            
            
        }
    }
    
}

extension ContainerViewController : ContainmentEventsManager {
    func raise(_ event: ContainmentEvent!, fromSender sender: ContainmentEventSource!) {
        
    }
}

