//
//  DefaultRatesInteractor.swift
//  
//
//  Created by Borja Arias Drake on 22.11.2020..
//

import Foundation

public class DefaultRatesInteractor {
    
    public func rates() -> [CurrencyCode : [CurrencyCode : NSDecimalNumber]] {
        return [.HRK : [.EUR : 0.13,
                        .GBP : 0.12,
                        .USD : 0.15],
                .EUR : [.HRK : 7.59,
                        .GBP : 0.90,
                        .USD : 1.01],
                .GBP : [.EUR : 1.10,
                        .HRK : 8.42,
                        .USD : 1.29],
                .USD : [.EUR : 0.86,
                        .GBP : 0.77,
                        .HRK : 6.50]]
    }
}
