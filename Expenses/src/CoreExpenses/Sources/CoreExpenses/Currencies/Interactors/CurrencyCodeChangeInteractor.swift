//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation

/// What to test
/// - When we should do convertions
/// - When we should't do convertions
/// Use case to detect changes in the locale and update the exchange rates if needed.
public class CurrencyCodeChangeInteractor {
    
    private var exchangeRatesConversionInteractor: CurrencyConvertorInteractor
    private var allEntriesDataSource: EntriesSummaryDataSource
    private var currencySettingsInteractor: CurrencySettingsInteractor
    
    public init(exchangeRatesConversionInteractor: CurrencyConvertorInteractor,
                allEntriesDataSource: EntriesSummaryDataSource,
                currencySettingsInteractor: CurrencySettingsInteractor) {
        self.exchangeRatesConversionInteractor = exchangeRatesConversionInteractor
        self.allEntriesDataSource = allEntriesDataSource
        self.currencySettingsInteractor = currencySettingsInteractor
    }
            
    public func updateCurrencyExchangeRates() async {
        let previousCode = currencySettingsInteractor.previousCurrencyCode()
        let currentCode = currencySettingsInteractor.currentCurrencyCode()
        let currencyCodeChanged = (previousCode != currentCode)
        if currencyCodeChanged {
            // Attempt conversion
            await convertExchangeRates(to: currentCode)
            
            // Regardless of whether the conversion succeeded or not (we are using harcoded default values),
            // we are setting the current currency code as the previous one, because we have indeed converted.
            currencySettingsInteractor.setPreviousCurrencyCode(currentCode)
        } else {
            // Even if there's no change, there could be some approximations.
            // Try to resolve them.
            await converExchangeRatesIfCalculationsAreApproximated()
        }                
    }
}

// MARK: - Helpers
private extension CurrencyCodeChangeInteractor {
    
    @discardableResult
    func convertExchangeRates(to newBase: String) async -> Bool {
        await exchangeRatesConversionInteractor.convertAllEntries(to: newBase)
        return allEntriesDataSource.isExchangeRateToBaseApproximated()
    }
    
    func converExchangeRatesIfCalculationsAreApproximated() async {
        // Check that we need to recalculate
        guard allEntriesDataSource.isExchangeRateToBaseApproximated() else {
            return
        }
        
        let currentCode = currencySettingsInteractor.currentCurrencyCode()
        await convertExchangeRates(to: currentCode)
    }
}
