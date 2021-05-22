//
//  asdfdf.swift
//  Expensit
//
//  Created by Borja Arias Drake on 11/11/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import CoreExpenses
import DateAndTime

public class CurrencyExchangeRatesDataSourceMapper: CurrencyExchangeRatesDataSource {
    
    private var dataSource: CurrencyExchangeRatesNetworkDataSource
    
    public init(dataSource: CurrencyExchangeRatesNetworkDataSource) {
        self.dataSource = dataSource
    }
    
    public func rates(from: String, to: [String], start: String, end: String) -> AnyPublisher<CurrencyExchangeInfo, Error> {
        return self.dataSource.rates(from: from, to: to, start: start, end: end).map { networkModel in
            var mappedRates = [String : [String : NSDecimalNumber]]()
            for (key, value) in networkModel.rates {
                var mappedRatesForCurrency = [String : NSDecimalNumber]()
                for (k2, v2) in value {
                    mappedRatesForCurrency[k2] = NSDecimalNumber(string: "\(v2)")
                }
                mappedRates[key] = mappedRatesForCurrency
            }
            
            
            return CurrencyExchangeInfo(rates: mappedRates,
                                        start_at: DateConversion.date(withFormat: DateFormats.reversedHyphenSeparated, from: networkModel.start_at),
                                        end_at: DateConversion.date(withFormat: DateFormats.reversedHyphenSeparated, from: networkModel.end_at),
                                        base: networkModel.base)
        }.eraseToAnyPublisher()
    }
    
    public func getLatest(from: String, to: [String]) -> AnyPublisher<CurrencyConversionRates, Never> {
        // TODO:
        // - Propagate error from network data source. Use interactor to use defaults in case of error, so that this
        //   code gets moved out.
        let rates: [CurrencyCode : [String : NSDecimalNumber]] = [.HRK : ["EUR" : 0.13,
                                                                          "GBP" : 0.12,
                                                                          "USD" : 0.15],
                                                                  .EUR : ["HRK" : 7.59,
                                                                          "GBP" : 0.90,
                                                                          "USD" : 1.01],
                                                                  .GBP : ["EUR" : 1.10,
                                                                          "HRK" : 8.42,
                                                                          "USD" : 1.29],
                                                                  .USD : ["EUR" : 0.86,
                                                                          "GBP" : 0.77,
                                                                          "HRK" : 6.50]]
                
        return Just(CurrencyConversionRates(rates: rates[CurrencyCode(rawValue: from)!]!,
                                            date: Date(),
                                            base: to.first!,
                                            isApproximation: true)).eraseToAnyPublisher()
    }

}
