//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 31/10/2020.
//

import Combine

public protocol CurrencyExchangeRatesDataSource {
    
    func rates(from: String, to: [String], start: String, end: String) -> AnyPublisher<CurrencyExchangeInfoNetworkModel, Never>
    func getLatest(from: String, to: [String]) -> AnyPublisher<CurrencyConversionRates, Never>
}
