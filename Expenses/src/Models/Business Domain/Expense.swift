//
//  BSExpenseEntry.swift
//  Expenses
//
//  Created by Borja Arias Drake on 15/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import Foundation


/// An expense represents the cost incurred in or required for something.
class Expense : NSObject {

    var identifier: NSCopying?
    var date: Date?
    var value: NSDecimalNumber
    var entryDescription: String?
    
    /// Categories are optional, becuase aggragated values are also represented as an expenses entry.
    /// For example the aggregation of all yearly entries is an value with an associated date, from which only the year is representative.
    /// In the case of aggregated entries, the category does not make sense, because multiple categories might be included.
    var category: ExpenseCategory?
    
    var year: UInt? {
        get {
            return self.date?.component(.year)
        }
    }

    var month: UInt? {
        get {
            return self.date?.component(.month)
        }
    }

    var day: UInt? {
        get {
            return self.date?.component(.day)
        }
    }

    init(date: Date?, value: NSDecimalNumber, description: String?, category: ExpenseCategory?) {
        self.date = date
        self.value = value
        self.entryDescription = description
        self.category = category
        super.init()
    }
}

extension Date {
    
    public func component(_ component: Calendar.Component) -> UInt
    {
        return UInt(Calendar(identifier: .gregorian).component(component, from: self))
        
    }
}
