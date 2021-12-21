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


public class ConvertToBaseCurrencyInteractor: CurrencyConvertorInteractor {
    
    private let entriesDataSource: EntriesSummaryDataSource
    private let ratesDataSource: CurrencyExchangeRatesDataSource
    private let saveExpense: EditExpenseInteractor
    private let defaultRates: DefaultRatesInteractor
    private let currenciesDataSource: CurrenciesDataSource
    private var rateInfoSubscription: AnyCancellable!
    
    public init(dataSource: EntriesSummaryDataSource,
                ratesDataSource: CurrencyExchangeRatesDataSource,
                saveExpense: EditExpenseInteractor,
                defaultRates: DefaultRatesInteractor,
                currenciesDataSource: CurrenciesDataSource) {
        self.entriesDataSource = dataSource
        self.ratesDataSource = ratesDataSource
        self.saveExpense = saveExpense
        self.defaultRates = defaultRates
        self.currenciesDataSource = currenciesDataSource
    }
    
    public func convertAllEntries(to newBaseCurrency: String) {
        // Get all entries from the DB
        // &
        // Get rates from the network
        let destinationCurrencies = currenciesDataSource.allUsedCurrencies()
        entriesDataSource.expensesGroups { expenseGroups in
            let firstDate = expenseGroups.first?.entries.first?.date
            let first = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: firstDate!.dayBefore)
            let lastDate = expenseGroups.last?.entries.last?.date
            let last = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: lastDate!.dayAfter)
            let ratesPublisher = self.ratesDataSource.rates(from: newBaseCurrency, to: destinationCurrencies, start: first, end: last).eraseToAnyPublisher()
            
            self.rateInfoSubscription = ratesPublisher.sink(receiveCompletion: { result in
                if case .failure(_) = result {
                    let updatedExpenses = self.expensesAfterUpdatingWithDefaultRates(expenseGroups: expenseGroups, to: newBaseCurrency)
                    self.save(expenses: updatedExpenses)
                }
            },
            receiveValue: { rateInfo in
                let updatedExpenses = self.expensesWithUpdatedExchangeRateToBase(expenseGroups: expenseGroups, rateInfo: rateInfo, to: newBaseCurrency)
                self.save(expenses: updatedExpenses)
            })
        }
    }
}

private extension ConvertToBaseCurrencyInteractor {
    
    func expensesWithUpdatedExchangeRateToBase(expenseGroups: [ExpensesGroup], rateInfo: CurrencyExchangeInfo, to baseCurrencyCode: String) -> [Expense] {
        let expenses = expenseGroups.flatMap { group in
            return group.entries
        }
        
        expenses.forEach { expense in
            let date = expense.date!
            let dateString = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: date)
            let dateDayAfterString = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: date.dayAfter)
            let dateDayBeforeString = DateConversion.string(withFormat: DateFormats.reversedHyphenSeparated, from: date.dayBefore)
            
            // We assume here that if for the date of interest we don't have a conversion rate, then looking for in the day before or after we'll always find one. This assumes that the only days without exchange rates are Saturdays and Sundays, which might not be true for all cases. We should implement a keep going in one direction until you find one.
            if let ratesForFrom = rateInfo.rates[dateString],
               let rateForBase = ratesForFrom[expense.currencyCode] {
                expense.exchangeRateToBaseCurrency = NSDecimalNumber(string: "\(rateForBase)")
                expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
                expense.isExchangeRateUpToDate = true
            } else if let ratesForFrom = rateInfo.rates[dateDayBeforeString],
                      let rateForBase = ratesForFrom[expense.currencyCode] {
                expense.exchangeRateToBaseCurrency = NSDecimalNumber(string: "\(rateForBase)")
                expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
                expense.isExchangeRateUpToDate = true
            } else if let ratesForFrom = rateInfo.rates[dateDayAfterString],
                      let rateForBase = ratesForFrom[expense.currencyCode] {
                expense.exchangeRateToBaseCurrency = NSDecimalNumber(string: "\(rateForBase)")
                expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
                expense.isExchangeRateUpToDate = true
            }
        }
        
        return expenses
    }
    
    func expensesAfterUpdatingWithDefaultRates(expenseGroups: [ExpensesGroup], to baseCurrencyCode: String) -> [Expense] {
        let expenses = expenseGroups.flatMap { group in
            return group.entries
        }
        
        expenses.forEach { expense in
            expense.exchangeRateToBaseCurrency = defaultRate(from: expense, base: baseCurrencyCode)
            expense.valueInBaseCurrency = expense.value.multiplying(by: expense.exchangeRateToBaseCurrency)
            expense.isExchangeRateUpToDate = (expense.currencyCode == baseCurrencyCode)
        }
        
        return expenses
    }
    
    func save(expenses: [Expense]) {
        _ = saveExpense.saveChanges(in: expenses)
    }
    
    /// Default conversion rate of expense.currencyCode
    /// - Returns: The default conversion rate from the defaults dictionary, or 1 if we couldn't find it.
    func defaultRate(from expense: Expense, base baseCurrencyCode: String) -> NSDecimalNumber {
        guard let expenseCurrency = CurrencyCode(rawValue: expense.currencyCode),
              let baseCurrency = CurrencyCode(rawValue: baseCurrencyCode),
              let rate = defaultRates.rates()[expenseCurrency]?[baseCurrency]
        else {
            return 1
        }
        
        return rate
    }
}
