//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 11/11/2020.
//

import Foundation


public struct CurrencyExchangeInfo {
    /*
     * - Structure: ["2018-01-08"  : [CODE : VALUE]]
     * - VALUE = BASE IN CODE
     */
    public let rates: [String : [String : NSDecimalNumber]]
    public let start_at: Date
    public let end_at: Date
    public let base: String
    
    public init(rates: [String : [String : NSDecimalNumber]],
                start_at: Date,
                end_at: Date,
                base: String) {
        self.rates = rates
        self.start_at = start_at
        self.end_at = end_at
        self.base = base
    }
}

public struct CurrencyConversionRates {
    public let rates: [String : NSDecimalNumber]
    public let date: Date
    public let base: String
    public let isApproximation: Bool
    
    public init(rates: [String : NSDecimalNumber],
    date: Date,
    base: String,
    isApproximation: Bool) {
        self.rates = rates
        self.date = date
        self.base = base
        self.isApproximation = isApproximation
    }
}
