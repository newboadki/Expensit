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
    required init(coreDataFetchController: BSCoreDataFetchController)
    {
        self.coreDataFetchController = coreDataFetchController
    }
    
    /// BSGraphLineControllerProtocol
    func abscissaValues() -> [NSDictionary] {
        return coreDataFetchController.abscissaValuesForYearlyLineGraph()
    }
    
    func graphSurplusResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphSurplusResultsForYearlyLineGraph(for:section)
    }
    
    func graphExpensesResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphExpensesResultsForYearlyLineGraph(for:section)
    }
}
