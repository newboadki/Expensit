//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 25/10/2020.
//

import Foundation

public class SupportedCurrenciesInteractor {

    private var currencyCodes: [String] = [CurrencyCode.EUR.rawValue,
                                           CurrencyCode.GBP.rawValue,
                                           CurrencyCode.HRK.rawValue,
                                           CurrencyCode.USD.rawValue]
    
    private let defaultCurrencyCode: String = CurrencyCode.USD.rawValue

    
    /// If the current locale has a currency code we use it. Otherwise we default to a predefined value from this class: 'defaultCurrencyCode'.
    public let currentLocaleCurrencyCode: String

    public let indexOfCurrentLocaleCurrencyCode: Int
    
    public init() {
        if let userCurrencyCode = Locale.current.currencyCode {
            if !self.currencyCodes.contains(userCurrencyCode) {
                self.currencyCodes.append(userCurrencyCode)
                self.currencyCodes.sort()
            }
            self.currentLocaleCurrencyCode = userCurrencyCode
        } else {
            self.currentLocaleCurrencyCode = CurrencyCode.USD.rawValue
        }
        
        self.indexOfCurrentLocaleCurrencyCode = self.currencyCodes.firstIndex(of: self.currentLocaleCurrencyCode)!
    }
    
    public func getAll() -> [String] {
        return self.currencyCodes
    }
}
