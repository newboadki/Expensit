//
//  CurrencyExchangeRatesDataSource.swift
//  
//
//  Created by Borja Arias Drake on 22.11.2020..
//

import Combine

public protocol CurrencyExchangeRatesDataSource {
    func rates(from: String, to: [String], start: String, end: String) -> AnyPublisher<CurrencyExchangeInfo, Error>
    func getLatest(from: String, to: [String]) -> AnyPublisher<CurrencyConversionRates, Never>
}
