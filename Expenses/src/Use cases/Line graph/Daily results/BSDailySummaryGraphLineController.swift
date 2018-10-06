//
//  BSDailySummaryGraphLineController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc class BSDailySummaryGraphLineController: NSObject, BSGraphLineControllerProtocol
{
    var coreDataFetchController : BSCoreDataFetchController
    
    /// CoreDataController protocol
    required init(coreDataFetchController: BSCoreDataFetchController)
    {
        self.coreDataFetchController = coreDataFetchController
    }

    /// BSGraphLineControllerProtocol
    func abscissaValues() -> [NSDictionary] {
        return coreDataFetchController.abscissaValuesForDailyLineGraph()
    }
    
    func graphSurplusResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphSurplusResultsForDailyLineGraph(for:section)
    }
    
    func graphExpensesResults(for section: String) -> [AnyObject] {
        return self.coreDataFetchController.graphExpensesResultsForDailyLineGraph(for:section)
    }
}
