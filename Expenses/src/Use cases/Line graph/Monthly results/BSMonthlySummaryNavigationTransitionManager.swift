//
//  BSMonthlySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

@objc class BSMonthlySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{
    
    @objc func configureDailyExpensesViewControllerWithSegue(_ segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let dailyExpensesViewController = segue.destination as! BSDailyExpensesSummaryViewController
        dailyExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let dailyController = BSShowDailyEntriesController(dataProvider: self.coreDataFetchController)
        let dailyPresenter = BSShowDailyEntriesPresenter(showEntriesUserInterface: dailyExpensesViewController, showEntriesController: dailyController)
        let dailyNavigationManager = BSDailySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController, coreDataFetchController: self.coreDataFetchController, containmentEventsDelegate:self.containmentEventsDelegate!)
        
        dailyExpensesViewController.showEntriesPresenter = dailyPresenter
        dailyExpensesViewController.showDailyEntriesPresenter = dailyPresenter
        dailyExpensesViewController.navigationTransitionManager = dailyNavigationManager
        dailyExpensesViewController.containmentEventsDelegate = self.containmentEventsDelegate!
    }
    
    @objc func configureMonthlyExpensesLineGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destination as! BSGraphViewController
        self.configureMonthylExpensesLineGraphViewController(graphViewController, section: section)
    }
    
    @objc func configureMonthylExpensesLineGraphViewController(_ graphViewController : BSGraphViewController, section : String) {
        let monthlyLineGraphController : BSGraphLineControllerProtocol = BSMonthlySummaryGraphLineController(coreDataFetchController:self.coreDataFetchController)
        let monthlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSMonthlySummaryGraphLinePresenter(monthlySummaryGraphLineController: monthlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = monthlyLineGraphPresenter

    }
    
    @objc func configureMonthlyExpensesPieGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate)
    {
        
        segue.destination.transitioningDelegate = animatedBlurEffectTransitioningDelegate;
        segue.destination.modalPresentationStyle = .custom

        let graphViewController = segue.destination as! BSPieChartViewController
        self.configureMonthylExpensesPieGraphViewController(graphViewController,
                                                            month: month,
                                                            year: year,
                                                            animatedBlurEffectTransitioningDelegate: animatedBlurEffectTransitioningDelegate)
    }
    
    @objc func configureMonthylExpensesPieGraphViewController(_ graphViewController : BSPieChartViewController, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate) {
        
        graphViewController.transitioningDelegate = animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = .custom
        
        let pieGraphController : BSPieGraphControllerProtocol = BSExpensesSummaryPieGraphController(dataProvider: self.coreDataFetchController)
        let pieGraphPresenter : BSPieGraphPresenterProtocol = BSExpensesSummaryPieGraphPresenter(pieGraphController: pieGraphController, month: month, year: NSNumber(integerLiteral: year))
        graphViewController.pieGraphPresenter = pieGraphPresenter
    }
    

}
