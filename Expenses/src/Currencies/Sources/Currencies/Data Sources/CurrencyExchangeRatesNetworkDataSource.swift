//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation
import Combine

public class CurrencyExchangeRatesNetworkDataSource: CurrencyExchangeRatesDataSource {
    
    /// In case of error retrieving rates from the network, these approximations will be used
    /// If a currency was not in the dictionary of default values, which would be a programming error, then this class will rerturn an error
    private static var defaultRates: [String : [String : NSDecimalNumber]] = [CurrencyCode.HRK.rawValue : [CurrencyCode.EUR.rawValue : 0.13,
                                                                                                           CurrencyCode.GBP.rawValue : 0.12,
                                                                                                           CurrencyCode.USD.rawValue : 0.15],
                                                                              CurrencyCode.EUR.rawValue : [CurrencyCode.HRK.rawValue : 7.59,
                                                                                                           CurrencyCode.GBP.rawValue : 0.90,
                                                                                                           CurrencyCode.USD.rawValue : 1.01],
                                                                              CurrencyCode.GBP.rawValue : [CurrencyCode.EUR.rawValue : 1.11,
                                                                                                           CurrencyCode.HRK.rawValue : 8.42,
                                                                                                           CurrencyCode.USD.rawValue : 1.29],
                                                                              CurrencyCode.USD.rawValue : [CurrencyCode.EUR.rawValue : 0.86,
                                                                                                           CurrencyCode.GBP.rawValue : 0.77,
                                                                                                           CurrencyCode.HRK.rawValue : 6.50]]

    
    private var cancellable: AnyCancellable?
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public init() {
        
    }
    
    public func rates(from: String, to: [String], start: String = "2013-01-01", end: String = "2020-10-17") -> AnyPublisher<CurrencyExchangeInfoNetworkModel, Never> {
        let url = URL(string: "https://api.exchangeratesapi.io/history?start_at=\(start)&end_at=\(end)&base=\(from)&symbols=\(to.joined(separator: ","))")!
        return urlSession.dataTaskPublisher(for: url)
                                .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: CurrencyExchangeInfoNetworkModel.self, decoder: JSONDecoder())
            .replaceError(with: CurrencyExchangeInfoNetworkModel(rates: [String : [String : Double]](), start_at: "", end_at: "", base: ""))
            .eraseToAnyPublisher()
    }
    
    public func getLatest(from: String, to: [String]) -> AnyPublisher<CurrencyConversionRates, Never> {
        let symbols = to.joined(separator: ",")
        let url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(from)&symbols=\(symbols)")!
        return urlSession.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, (httpResponse.statusCode == 200) else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: LatestCurrencyExchangeInfoNetworkModel.self, decoder: JSONDecoder())
            .map { networkModel in
                let rates = Dictionary(uniqueKeysWithValues:networkModel.rates.map { key, value in (key, NSDecimalNumber(string: "\(value)")) })
                return CurrencyConversionRates(rates: rates,
                                               date: Date(),
                                               base: networkModel.base,
                                               isApproximation: false)
            }
            .replaceError(with: defaultRates(for: from))
            .eraseToAnyPublisher()
    }
    
    private func defaultRates(for base: String) -> CurrencyConversionRates {        
        var ratesForBase: [String : NSDecimalNumber]
        
        if let _ = CurrencyCode(rawValue: base) {
            ratesForBase = CurrencyExchangeRatesNetworkDataSource.defaultRates[base]!
        } else {
            ratesForBase = [String : NSDecimalNumber]()
        }
         
        return CurrencyConversionRates(rates: ratesForBase,
                                       date: Date(),
                                       base: base,
                                       isApproximation: true)
    }
}
