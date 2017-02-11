//
//  BSMonthlySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class BSMonthlySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{
    
    func configureDailyExpensesViewControllerWithSegue(_ segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let dailyExpensesViewController = segue.destination as! BSDailyExpensesSummaryViewController
        dailyExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let dailyController = BSShowDailyEntriesController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let dailyPresenter = BSShowDailyEntriesPresenter(showEntriesUserInterface: dailyExpensesViewController, showEntriesController: dailyController)
        let dailyNavigationManager = BSDailySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController, containmentEventsDelegate:self.containmentEventsDelegate!)
        
        dailyExpensesViewController.showEntriesController = (dailyController as BSAbstractShowEntriesControllerProtocol)
        dailyExpensesViewController.showEntriesPresenter = dailyPresenter
        dailyExpensesViewController.showDailyEntriesPresenter = dailyPresenter
        dailyExpensesViewController.navigationTransitionManager = dailyNavigationManager
        dailyExpensesViewController.containmentEventsDelegate = self.containmentEventsDelegate!
    }
    
    func configureMonthlyExpensesLineGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destination as! BSGraphViewController
        self.configureMonthylExpensesLineGraphViewController(graphViewController, section: section)
    }
    
    func configureMonthylExpensesLineGraphViewController(_ graphViewController : BSGraphViewController, section : String) {
        let monthlyLineGraphController : BSGraphLineControllerProtocol = BSMonthlySummaryGraphLineController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let monthlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSMonthlySummaryGraphLinePresenter(monthlySummaryGraphLineController: monthlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = monthlyLineGraphPresenter

    }
    
    func configureMonthlyExpensesPieGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate)
    {
        let graphViewController = segue.destination as! BSPieChartViewController
        self.configureMonthylExpensesPieGraphViewController(graphViewController,
                                                            month: month,
                                                            year: year,
                                                            animatedBlurEffectTransitioningDelegate: animatedBlurEffectTransitioningDelegate)
    }
    
    func configureMonthylExpensesPieGraphViewController(_ graphViewController : BSPieChartViewController, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate) {
        
        graphViewController.transitioningDelegate = animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = .custom
        
        let pieGraphController : BSPieGraphControllerProtocol = BSExpensesSummaryPieGraphController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let pieGraphPresenter : BSPieGraphPresenterProtocol = BSExpensesSummaryPieGraphPresenter(pieGraphController: pieGraphController, month: month, year: NSNumber(integerLiteral: year))
        graphViewController.pieGraphPresenter = pieGraphPresenter
    }
    

}
