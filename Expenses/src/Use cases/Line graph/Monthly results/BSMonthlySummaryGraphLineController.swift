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
    @objc required init(coreDataFetchController: BSCoreDataFetchController)
    {
        self.coreDataFetchController = coreDataFetchController
    }


    /// BSGraphLineControllerProtocol
    
    @objc func abscissaValues() -> [NSDictionary] {
        return self.coreDataFetchController.abscissaValuesForMonthlyLineGraph()
    }
    
    @objc func graphSurplusResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphSurplusResultsForMonthlyLineGraph(for:section)
    }
    
    @objc func graphExpensesResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphExpensesResultsForMonthlyLineGraph(for:section)
    }
}
