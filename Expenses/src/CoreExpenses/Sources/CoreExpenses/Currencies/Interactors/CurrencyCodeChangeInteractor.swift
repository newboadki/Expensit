//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation

public class CurrencyCodeChangeInteractor {
    
    private var exchangeRatesConversionInteractor: ConvertToBaseCurrencyInteractor
    private var allEntriesDataSource: EntriesSummaryDataSource
    private var currencySettingsInteractor: CurrencySettingsInteractor
    
    public init(exchangeRatesConversionInteractor: ConvertToBaseCurrencyInteractor,
                allEntriesDataSource: EntriesSummaryDataSource,
                currencySettingsInteractor: CurrencySettingsInteractor) {
        self.exchangeRatesConversionInteractor = exchangeRatesConversionInteractor
        self.allEntriesDataSource = allEntriesDataSource
        self.currencySettingsInteractor = currencySettingsInteractor
    }
            
    public func updateCurrencyExchangeRatesIfNeeded() {
        let previousCode = currencySettingsInteractor.previousCurrencyCode()
        let currentCode = currencySettingsInteractor.currentCurrencyCode()
        let currencyCodeChanged = (previousCode != currentCode)
        if currencyCodeChanged {
            // Convert
            let approximated = convertExchangeRates(from: previousCode, to: currentCode)
            
            // Update state if needed
            if !approximated {
                currencySettingsInteractor.setPreviousCurrencyCode(currentCode)
            }
        } else {
            converExchangeRatesIfCalculationsAreApproximated()
        }
    }
    
    private func convertExchangeRates(from: String, to: String) -> Bool {
        exchangeRatesConversionInteractor.convertAllEntries(from: from, to: to)
        return allEntriesDataSource.isExchangeRateToBaseApproximated()
    }
    
    private func converExchangeRatesIfCalculationsAreApproximated() {
        // Check that we need to recalculate
        guard allEntriesDataSource.isExchangeRateToBaseApproximated() else {
            return
        }
        
        // Check the state is not corrupt
        let previousCode = currencySettingsInteractor.previousCurrencyCode()
        let currentCode = currencySettingsInteractor.currentCurrencyCode()
        guard (previousCode != currentCode) else {
            fatalError("Currency rates can't be approximate if current and previous codes are the same.")
        }
        
        // Convert
        let approximated = convertExchangeRates(from: previousCode, to: currentCode)
        
        // Update state if needed
        if !approximated {
            currencySettingsInteractor.setPreviousCurrencyCode(currentCode)
        }
    }
}
