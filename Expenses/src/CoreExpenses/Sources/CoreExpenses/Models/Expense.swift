//
//  BSExpenseEntry.swift
//  Expenses
//
//  Created by Borja Arias Drake on 15/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import Foundation


/// An expense represents the cost incurred in or required for something.
/// TODO: Make it a value type
public class Expense {

    public var identifier: NSCopying? // Related to the underlying storage system
    public let dateComponents: DateComponents
    public var date: Date?
    public var value: NSDecimalNumber
    public var entryDescription: String?
    public var currencyCode: String
        
    /// This is optional because when we group by any time amount this field does not make sense.
    /// It is only populated when the expense represents a single entry. In this case, the amount of the entry
    /// Is in a given currency, that might or might not be the base currency. Therefore, 'exchangeRateToBaseCurrency'
    /// Contains a value.
    public var exchangeRateToBaseCurrency: NSDecimalNumber?
    
    /// Categories are optional, because aggregated values are also represented as an expenses entry.
    /// For example the aggregation of all yearly entries is an value with an associated date, from which only the year is representative.
    /// In the case of aggregated entries, the category does not make sense, because multiple categories might be included.
    public var category: ExpenseCategory?
    
    public var year: Int? {
        get {
            return self.date?.component(.year)
        }
    }

    public var month: Int? {
        get {
            return self.date?.component(.month)
        }
    }

    public var day: Int? {
        get {
            return self.date?.component(.day)
        }
    }
    
    public var isAmountNegative: BSNumberSignType {
        get {
            switch value.compare(0) {
                case .orderedAscending:
                    return .negative
                case .orderedDescending:
                    return .positive
                case .orderedSame:
                    return .zero                
            }
        }
    }

    public init(dateComponents: DateComponents, date: Date?, value: NSDecimalNumber, description: String?, category: ExpenseCategory?, currencyCode: String, exchangeRateToBaseCurrency: NSDecimalNumber? = nil) {
        self.dateComponents = dateComponents
        self.date = date
        self.value = value
        self.entryDescription = description
        self.category = category
        self.currencyCode = currencyCode
        self.exchangeRateToBaseCurrency = exchangeRateToBaseCurrency
    }
    
    public func isInBaseCurrency() -> Bool {
        guard let baseCurrencyCode = Locale.current.currencyCode else {
            return false
        }
        return (currencyCode == baseCurrencyCode)
    }
}
