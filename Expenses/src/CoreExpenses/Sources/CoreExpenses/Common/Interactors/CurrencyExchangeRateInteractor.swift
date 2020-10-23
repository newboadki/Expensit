//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 17/10/2020.
//

import Foundation

class CurrencyExchangeRateInteractor {
    
    private static var rates: [CurrencyCode : [CurrencyCode : Double]] = [.HRK : [.EUR : 7.5,
                                                                                  .GBP : 10.5,
                                                                                  .USD : 8.0]]
    
    static func rateBetween(base: CurrencyCode, and secondary: CurrencyCode) -> Double? {
        guard let ratesForBase = rates[base] else {
            return nil
        }
        
        guard let secondaryRate = ratesForBase[secondary] else {
            return nil
        }
        
        return secondaryRate
    }
}
