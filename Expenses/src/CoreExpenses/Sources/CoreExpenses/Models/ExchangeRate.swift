//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 11/11/2020.
//

import Foundation


public struct CurrencyExchangeInfo {
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
