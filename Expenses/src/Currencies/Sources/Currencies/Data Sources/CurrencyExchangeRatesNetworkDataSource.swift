//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation
import Combine

class CurrencyExchangeRatesNetworkDataSource {
    
    private var cancellable: AnyCancellable?
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    func get() {
        let url = URL(string: "https://api.exchangeratesapi.io/history?start_at=2013-01-01&end_at=2020-10-17&base=EUR&symbols=HRK,GBP")!
        cancellable = urlSession.dataTaskPublisher(for: url)
                                .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: CurrencyExchangeInfoNetworkModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: {
                    print ("Received completion: \($0).")
            },
            receiveValue: { user in
                print ("Received user: \(user).")})
    }
    
}
