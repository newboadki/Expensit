//
//  File.swift
//
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation
import Combine
import CoreExpenses

public class CurrencyExchangeRatesNetworkDataSource {

    /// In case of error retrieving rates from the network, these approximations will be used
    /// If a currency was not in the dictionary of default values, which would be a programming error, then this class will rerturn an error
    private static var defaultRates: [String : [String : Double]] = ["HRK" : ["EUR" : 0.13,
                                                                               "GBP" : 0.12,
                                                                               "USD" : 0.15],
                                                                      "EUR" : ["HRK" : 7.59,
                                                                               "GBP" : 0.90,
                                                                               "USD" : 1.01],
                                                                      "GBP" : ["EUR" : 1.11,
                                                                               "HRK" : 8.42,
                                                                               "USD" : 1.29],
                                                                      "USD" : ["EUR" : 0.86,
                                                                               "GBP" : 0.77,
                                                                               "HRK" : 6.50]]

    
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

    public func getLatest(from: String, to: [String]) -> AnyPublisher<LatestCurrencyExchangeInfoNetworkModel, Never> {
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
                //let rates = Dictionary(uniqueKeysWithValues:networkModel.rates.map { key, value in (key, NSDecimalNumber(string: "\(value)")) })
                return LatestCurrencyExchangeInfoNetworkModel(rates: networkModel.rates,
                                                              date: "",
                                                              base: networkModel.base)
            }
            .replaceError(with: defaultRates(for: from))
            .eraseToAnyPublisher()
    }

    private func defaultRates(for base: String) -> LatestCurrencyExchangeInfoNetworkModel {
        return LatestCurrencyExchangeInfoNetworkModel(rates: CurrencyExchangeRatesNetworkDataSource.defaultRates[base]!,
                                                      date: "",
                                                      base: base)
    }
}
