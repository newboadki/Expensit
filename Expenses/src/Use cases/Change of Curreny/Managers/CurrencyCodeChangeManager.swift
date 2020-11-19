//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation
import Currencies
import CoreExpenses
import CoreDataPersistence

class CurrencyCodeChangeManager {
    
    private var exchangeRatesConversionInteractor: ConvertToBaseCurrencyInteractor
    private var allEntriesDataSource: AllEntriesCoreDataExpensesDataSource
    private var currencySettingsInteractor: CurrencySettingsInteractor
    
    init(exchangeRatesConversionInteractor: ConvertToBaseCurrencyInteractor,
         allEntriesDataSource: AllEntriesCoreDataExpensesDataSource,
         currencySettingsInteractor: CurrencySettingsInteractor) {
        self.exchangeRatesConversionInteractor = exchangeRatesConversionInteractor
        self.allEntriesDataSource = allEntriesDataSource
        self.currencySettingsInteractor = currencySettingsInteractor
    }
            
    func converExchangeRatesIfCurrencyChanged() {
        let previousCode = currencySettingsInteractor.previousCurrencyCode()
        let currentCode = currencySettingsInteractor.currentCurrencyCode()

        guard (previousCode != currentCode) else {
            return
        }
        
        exchangeRatesConversionInteractor.convertAllEntries(from: previousCode, to: currentCode)
        let ratesAreApproximated = allEntriesDataSource.isExchangeRateToBaseApproximated()
        if !ratesAreApproximated {
            currencySettingsInteractor.setPreviousCurrencyCode(currentCode)
        }
    }
    
    func converExchangeRatesIfCalculationsAreApproximated() {
        guard allEntriesDataSource.isExchangeRateToBaseApproximated() else {
            return
        }
        
        let previousCode = currencySettingsInteractor.previousCurrencyCode()
        let currentCode = currencySettingsInteractor.currentCurrencyCode()
        
        guard (previousCode != currentCode) else {
            return
        }
        
        exchangeRatesConversionInteractor.convertAllEntries(from: previousCode, to: currentCode)
        
        if !allEntriesDataSource.isExchangeRateToBaseApproximated() {
            currencySettingsInteractor.setPreviousCurrencyCode(currentCode)
        }
    }
}
