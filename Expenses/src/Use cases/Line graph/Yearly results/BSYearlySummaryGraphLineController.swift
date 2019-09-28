//
//  BSYearlySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSYearlySummaryGraphLineController: NSObject, BSGraphLineControllerProtocol
{
    var coreDataFetchController : BSCoreDataFetchController
    
    /// CoreDataController protocol
    @objc required init(coreDataFetchController: BSCoreDataFetchController)
    {
        self.coreDataFetchController = coreDataFetchController
    }
    
    /// BSGraphLineControllerProtocol
    @objc func abscissaValues() -> [NSDictionary] {
        return coreDataFetchController.abscissaValuesForYearlyLineGraph()
    }
    
    @objc func graphSurplusResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphSurplusResultsForYearlyLineGraph(for:section)
    }
    
    @objc func graphExpensesResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphExpensesResultsForYearlyLineGraph(for:section)
    }
}
