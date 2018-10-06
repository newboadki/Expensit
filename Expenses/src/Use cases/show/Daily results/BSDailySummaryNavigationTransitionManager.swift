//
//  BSDailySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

import UIKit

class BSDailySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{
    func configureDailyExpensesLineGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destination as! BSGraphViewController
        self.configureDailylExpensesLineGraphViewController(graphViewController, section: section)
    }
    
    func configureDailylExpensesLineGraphViewController(_ graphViewController : BSGraphViewController, section : String) {
        let dailyLineGraphController : BSGraphLineControllerProtocol = BSDailySummaryGraphLineController(coreDataFetchController:self.coreDataFetchController)
        let dailyLineGraphPresenter : BSGraphLinePresenterProtocol = BSDailySummaryGraphLinePresenter(dailySummaryGraphLineController: dailyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = dailyLineGraphPresenter
    }

    func configureMonthlyExpensesPieGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate)
    {
        let graphViewController = segue.destination as! BSPieChartViewController
        self.configureDailyExpensesPieGraphViewControllerWithSegue(graphViewController, month: month, year: year, animatedBlurEffectTransitioningDelegate: animatedBlurEffectTransitioningDelegate)
    }
    
    func configureDailyExpensesPieGraphViewControllerWithSegue(_ graphViewController: BSPieChartViewController, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate) {
        graphViewController.transitioningDelegate = animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = .custom
        let pieGraphController : BSPieGraphControllerProtocol = BSExpensesSummaryPieGraphController(dataProvider: self.coreDataFetchController)
        let pieGraphPresenter : BSPieGraphPresenterProtocol = BSExpensesSummaryPieGraphPresenter(pieGraphController: pieGraphController, month: month, year: NSNumber(integerLiteral: year))
        graphViewController.pieGraphPresenter = pieGraphPresenter
        
    }
    
    func configureAllExpensesViewControllerWithSegue(_ segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let allExpensesViewController = segue.destination as! BSIndividualExpensesSummaryViewController
        allExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let dailyNavigationManager = BSIndividualEntriesSummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController, coreDataFetchController: self.coreDataFetchController, containmentEventsDelegate:self.containmentEventsDelegate!)
        allExpensesViewController.navigationTransitionManager = dailyNavigationManager
        let allController = BSShowAllEntriesController(dataProvider: self.coreDataFetchController)
        let allPresenter = BSShowAllEntriesPresenter(showEntriesUserInterface: allExpensesViewController, showEntriesController: allController)
                
        allExpensesViewController.showEntriesPresenter = allPresenter
        allExpensesViewController.containmentEventsDelegate = self.containmentEventsDelegate!
        
    }
    
    


}
