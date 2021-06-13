//
//  File.swift
//
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation
import Combine
import CoreExpenses


/// To test this class we should use an HTTTPClient abstraction.
/// - We should test that errors are caught and defaults used.
/// - We should test that in case of success we return the network-layer models correctly populated
/// 81b7f4c36a84a9ef1c9f2dbc870dfc0b
// http://api.exchangeratesapi.io/v1/2021-01-24?&base=EUR&symbols=GBP,%20USD&access_key=81b7f4c36a84a9ef1c9f2dbc870dfc0b
public class CurrencyExchangeRatesNetworkDataSource {

    private var cancellable: AnyCancellable?
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public init() {
        
    }

    // From needs to be an array
    // The return type has to be [CurrencyExchangeInfoNetworkModel]
    public func rates(from baseCurrencyCode: String, to destinationCurrencyCodes: [String], start: String = "2013-01-01", end: String = "2020-10-17") -> AnyPublisher<CurrencyExchangeInfoNetworkModel, Error> {
        let url = URL(string: "https://api.exchangeratesapi.io/history?start_at=\(start)&end_at=\(end)&base=\(baseCurrencyCode)&symbols=\(destinationCurrencyCodes.joined(separator: ","))&access_token=81b7f4c36a84a9ef1c9f2dbc870dfc0b")!
        return urlSession.dataTaskPublisher(for: url)
                                .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: CurrencyExchangeInfoNetworkModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    ///http://api.exchangeratesapi.io/latest?access_key=81b7f4c36a84a9ef1c9f2dbc870dfc0b&base=EUR&symbols=GBP,USD
    public func getLatest(from: String, to: [String]) -> AnyPublisher<LatestCurrencyExchangeInfoNetworkModel, Error> {
        let symbols = to.joined(separator: ",")
        let url = URL(string: "https://api.exchangeratesapi.io/latest?access_key=81b7f4c36a84a9ef1c9f2dbc870dfc0b&base=\(from)&symbols=\(symbols)")!
        return urlSession.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, (httpResponse.statusCode == 200) else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: LatestCurrencyExchangeInfoNetworkModel.self, decoder: JSONDecoder())
            .map { networkModel in
                return LatestCurrencyExchangeInfoNetworkModel(rates: networkModel.rates,
                                                              date: "",
                                                              base: networkModel.base)
            }
            .eraseToAnyPublisher()
    }
}
