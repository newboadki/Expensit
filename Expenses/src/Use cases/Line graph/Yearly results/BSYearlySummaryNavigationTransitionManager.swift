//
//  BSYearlySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

@objc class BSYearlySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{    
    @objc func configureMonthlyExpensesViewControllerWithSegue(_ segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let monthlyExpensesViewController = segue.destination as! BSMonthlyExpensesSummaryViewController
        monthlyExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let monthlyController = BSShowMonthlyEntriesController(dataProvider: self.coreDataFetchController)
        let monthlyPresenter = BSShowMonthlyEntriesPresenter(showEntriesUserInterface: monthlyExpensesViewController, showEntriesController: monthlyController)
        let monthlyNavigationManager = BSMonthlySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController, coreDataFetchController: self.coreDataFetchController, containmentEventsDelegate:self.containmentEventsDelegate!)
        
        monthlyExpensesViewController.showEntriesPresenter = monthlyPresenter
        monthlyExpensesViewController.navigationTransitionManager = monthlyNavigationManager
        monthlyExpensesViewController.containmentEventsDelegate = self.containmentEventsDelegate!
    }
    
    @objc func configureYearlyExpensesLineGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destination as! BSGraphViewController
        self.configureYearlyExpensesLineGraphViewController(graphViewController, section: section)
    }
    
    @objc func configureYearlyExpensesLineGraphViewController(_ graphViewController : BSGraphViewController, section : String) {
        let yearlyLineGraphController : BSGraphLineControllerProtocol = BSYearlySummaryGraphLineController(coreDataFetchController:self.coreDataFetchController)
        let yearlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSYearlySummaryGraphLinePresenter(yearlySummaryGraphLineController: yearlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = yearlyLineGraphPresenter

    }
}
