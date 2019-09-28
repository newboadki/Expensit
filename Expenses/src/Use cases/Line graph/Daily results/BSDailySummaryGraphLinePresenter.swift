//
//  BSDailySummaryGraphLinePresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc public class BSDailySummaryGraphLinePresenter: NSObject, BSGraphLinePresenterProtocol {
    
    var dailySummaryGraphLineController : BSGraphLineControllerProtocol
    var section: String
    
    
    @objc init!(dailySummaryGraphLineController : BSGraphLineControllerProtocol, section: String)
    {
        self.dailySummaryGraphLineController = dailySummaryGraphLineController
        self.section = section as String
        super.init()
    }
    
    
    func income() -> [AnyObject] {
        let data = self.dailySummaryGraphLineController.graphSurplusResults(for: self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data) // Get the data from cntroller

    }
    
    func expenses() -> [AnyObject] {
        let data = self.dailySummaryGraphLineController.graphExpensesResults(for: self.section)
        return self.dataForGraphFromQueryResults(data)
    }
    
    func abscissaValues() -> [String] {
        var days = [String]()
        let monthNumber = self.section.components(separatedBy: "/")[0]
        let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: monthNumber).length
        for i in 0 ..< numberOfDayInMonths {
            days.append("\(i+1)")
        }

        return days
    }
    
    func graphTitle() -> String {
        return self.section
    }
    
    
    /// Helper private
    func dataForGraphFromQueryResults(_ data : [AnyObject])  -> [NSNumber] {
        let monthNumber = self.section.components(separatedBy: "/")[0]
        let numberOfDaysInMonth = DateTimeHelper.numberOfDays(inMonth: monthNumber)
        var graphData = Array<NSNumber>(repeating: 0, count: numberOfDaysInMonth.length)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let day = dictionary["day"] as! Int
            let dailySum = dictionary["dailySum"] as! NSNumber
            let dailySumAsDouble = dailySum.doubleValue
            if dailySumAsDouble > 0 {
                graphData[day] = NSNumber(value: dailySumAsDouble)
            } else {
                if day > 0 && day < numberOfDaysInMonth.length {                    
                    graphData[day] = NSNumber(value: -dailySumAsDouble)
                } else {
                    
                }
            }
        }
        
        return graphData
    }
    
}
