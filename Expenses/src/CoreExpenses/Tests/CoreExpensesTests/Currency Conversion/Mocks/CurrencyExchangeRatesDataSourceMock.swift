//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 26.04.2021..
//

@testable import CoreExpenses
import Combine

class CurrencyExchangeRatesDataSourceMock: CurrencyExchangeRatesDataSource {
    
    struct GenericError: Error {}

    private var exchangeInfo: CurrencyExchangeInfo
    private var rates: CurrencyConversionRates
    private var forcedError: Error?

    init(exchangeInfo: CurrencyExchangeInfo, rates: CurrencyConversionRates, error: Error? = nil) {
        self.exchangeInfo = exchangeInfo
        self.rates = rates
        self.forcedError = error
    }

    func rates(from: String, to: [String], start: String, end: String) -> AnyPublisher<CurrencyExchangeInfo, Error> {
        guard forcedError == nil else {
            return Fail(error: forcedError!).eraseToAnyPublisher()
        }
        
        return Just(exchangeInfo)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getLatest(from: String, to: [String]) -> AnyPublisher<CurrencyConversionRates, Never> {
        Just(rates).eraseToAnyPublisher()
    }
}
