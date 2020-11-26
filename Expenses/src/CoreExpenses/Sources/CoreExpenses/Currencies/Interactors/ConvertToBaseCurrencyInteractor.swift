//
//  ConvertToBaseCurrencyInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 06/11/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import DateAndTime

public class ConvertToBaseCurrencyInteractor {
    
    private var entriesDataSource: EntriesSummaryDataSource
    private var ratesDataSource: CurrencyExchangeRatesDataSource
    private var saveExpense: EditExpenseInteractor
    private var rateInfoSubscription: AnyCancellable!
    
    public init(dataSource: EntriesSummaryDataSource,
         ratesDataSource: CurrencyExchangeRatesDataSource,
         saveExpense: EditExpenseInteractor) {
        self.entriesDataSource = dataSource
        self.ratesDataSource = ratesDataSource
        self.saveExpense = saveExpense
    }
    
    public func convertAllEntries(from: String, to baseCurrencyCode: String) {
        // Get all entries from the DB
        // &
        // Get rates from the network
        let expenseGroups = entriesDataSource.expensesGroups()
        let firstDate = expenseGroups.first?.entries.first?.date
        let first = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: firstDate!.dayBefore)
        let lastDate = expenseGroups.last?.entries.last?.date
        let last = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: lastDate!.dayAfter)
        let ratesPublisher = self.ratesDataSource.rates(from: from, to: [baseCurrencyCode], start: first, end: last).eraseToAnyPublisher()
        self.rateInfoSubscription = ratesPublisher.sink(receiveValue: { rateInfo in
            let updatedExpenses = self.expensesWithUpdatedExchangeRateToBase(expenseGroups: expenseGroups,
                                                                             rateInfo: rateInfo,
                                                                             from: from,
                                                                             to: baseCurrencyCode)
            self.save(expenses: updatedExpenses)
        })
    }
    
    private func expensesWithUpdatedExchangeRateToBase(expenseGroups: [ExpensesGroup], rateInfo: CurrencyExchangeInfo, from: String, to baseCurrencyCode: String) -> [Expense] {
        let expenses = expenseGroups.flatMap { group in
            return group.entries
        }
        
        expenses.forEach { expense in
            let date = expense.date!
            let dateString = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: date)
            let dateDayAfterString = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: date.dayAfter)
            let dateDayBeforeString = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: date.dayBefore)
            
            if let ratesForFrom = rateInfo.rates[dateString],
               let rateForBase = ratesForFrom[baseCurrencyCode] {
                expense.exchangeRateToBaseCurrency = NSDecimalNumber(string: "\(rateForBase)")
                expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
                expense.isExchangeRateUpToDate = true
            } else if let ratesForFrom = rateInfo.rates[dateDayBeforeString],
                      let rateForBase = ratesForFrom[baseCurrencyCode] {
                expense.exchangeRateToBaseCurrency = NSDecimalNumber(string: "\(rateForBase)")
                expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
                expense.isExchangeRateUpToDate = true
            } else if let ratesForFrom = rateInfo.rates[dateDayAfterString],
                      let rateForBase = ratesForFrom[baseCurrencyCode] {
                expense.exchangeRateToBaseCurrency = NSDecimalNumber(string: "\(rateForBase)")
                expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
                expense.isExchangeRateUpToDate = true
            }
        }
        
        return expenses
    }
    
    private func save(expenses: [Expense]) {
        _ = saveExpense.saveChanges(in: expenses)
    }

}

