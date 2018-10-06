//
//  BSMonthlySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 08/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSMonthlySummaryGraphLineController: NSObject, BSGraphLineControllerProtocol
{
    var coreDataFetchController : BSCoreDataFetchController
    
    /// CoreDataController protocol
    required init(coreDataFetchController: BSCoreDataFetchController)
    {
        self.coreDataFetchController = coreDataFetchController
    }


    /// BSGraphLineControllerProtocol
    
    func abscissaValues() -> [NSDictionary] {
        return self.coreDataFetchController.abscissaValuesForMonthlyLineGraph()
    }
    
    func graphSurplusResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphSurplusResultsForMonthlyLineGraph(for:section)
    }
    
    func graphExpensesResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphExpensesResultsForMonthlyLineGraph(for:section)
    }
}
