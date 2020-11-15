//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation

public struct CurrencyExchangeInfoNetworkModel: Codable {
    public let rates: [String : [String : Double]]
    public let start_at: String
    public let end_at: String
    public let base: String
}

public struct LatestCurrencyExchangeInfoNetworkModel: Codable {
    let rates: [String : Double]
    let date: String
    let base: String
}

public struct CurrencyConversionRates {
    public let rates: [String : NSDecimalNumber]
    public let date: Date
    public let base: String
    public let isApproximation: Bool        
}
