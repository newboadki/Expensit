//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation
import CoreExpenses

class CurrencySettingsDefaultDataSource: CurrencySettingsDataSource {
    
    var currentCurrencyCode: String {
        get {
            Locale.current.currencyCode!
        }
    }
    
    var previousCurrencyCode: String {
        get {
            guard let storedValue = UserDefaults.standard.value(forKey: kPreviousLocaleCurrencyCode) as? String else {
                return Locale.current.currencyCode!
            }
            
            return storedValue
            
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: kPreviousLocaleCurrencyCode)
        }
    }
}

