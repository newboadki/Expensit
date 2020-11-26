//
//  DefaultRatesInteractor.swift
//  
//
//  Created by Borja Arias Drake on 22.11.2020..
//

import Foundation

class DefaultRatesInteractor {
    
    func rates() -> [String : [String : NSDecimalNumber]] {
        return [CurrencyCode.HRK.rawValue : [CurrencyCode.EUR.rawValue : 0.13,
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
    }
}
