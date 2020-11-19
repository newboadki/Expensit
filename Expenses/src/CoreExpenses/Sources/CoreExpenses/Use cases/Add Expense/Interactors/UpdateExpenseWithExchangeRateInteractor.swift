//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 24/10/2020.
//

import Foundation
import Currencies
import Combine

public class UpdateExpenseWithExchangeRateInteractor {
    
    private var dataSource: CurrencyExchangeRatesDataSource
    private var currenciesInteractor: SupportedCurrenciesInteractor
    
    public init(dataSource: CurrencyExchangeRatesDataSource,
                currenciesInteractor: SupportedCurrenciesInteractor) {
        self.dataSource = dataSource
        self.currenciesInteractor = currenciesInteractor
    }
    
    public func update(_ expense: Expense) -> AnyPublisher<Expense, Never> {        
        let from = expense.currencyCode
        let to = currenciesInteractor.currentLocaleCurrencyCode
        
        // If already in the base currency then return the expense
        guard from != to else {
            expense.valueInBaseCurrency = expense.value
            expense.exchangeRateToBaseCurrency = 1
            expense.isExchangeRateUpToDate = true
            return Just(expense).eraseToAnyPublisher()
        }
                
        return dataSource.getLatest(from: from, to: [to]).flatMap { rate -> AnyPublisher<Expense, Never> in
            let conversionRate = rate.rates[to] ?? 1 // If the currency is unknown (not in the defaults) assume 1.0.
            expense.valueInBaseCurrency = expense.value.multiplying(by: conversionRate)
            expense.exchangeRateToBaseCurrency = conversionRate
            expense.isExchangeRateUpToDate = !rate.isApproximation
            return Just(expense).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
