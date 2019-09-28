//
//  BSMonthlySummaryGraphLinePresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 08/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSMonthlySummaryGraphLinePresenter: NSObject, BSGraphLinePresenterProtocol {
    
    var monthlySummaryGraphLineController : BSGraphLineControllerProtocol
    var section: String
    
    
    @objc init(monthlySummaryGraphLineController : BSGraphLineControllerProtocol, section: String)
    {
        self.monthlySummaryGraphLineController = monthlySummaryGraphLineController
        self.section = section
        super.init()
    }
    
    
    func income() -> [AnyObject] {
        let data = self.monthlySummaryGraphLineController.graphSurplusResults(for: self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data)
    }
    
    func expenses() -> [AnyObject] {
        let data = self.monthlySummaryGraphLineController.graphExpensesResults(for: self.section)
        return self.dataForGraphFromQueryResults(data)
    }
    
    func abscissaValues() -> [String] {
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }

    func graphTitle() -> String {
        return self.section
    }

    
    /// Helper private
    func dataForGraphFromQueryResults(_ data : [AnyObject])  -> [AnyObject] {
        var graphData = Array<NSNumber>(repeating: 0, count: 12)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let month = dictionary["month"] as! Int
            let monthlySum = dictionary["monthlySum"] as! NSNumber
            if monthlySum.compare(NSNumber(floatLiteral: 0.0)) == .orderedDescending {
                // positive
                graphData[month-1] = monthlySum
            } else {
                // negative
                let decimalValue = NSDecimalNumber(value: monthlySum.doubleValue)
                graphData[month-1] = decimalValue.multiplying(by: NSDecimalNumber(value: -1.0))
            }            
        }
        
        return graphData
    }
    
}
