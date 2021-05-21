//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation

public struct CurrencyExchangeInfoNetworkModel: Codable {
    
    /*
     * - Structure: ["2018-01-08"  : [CODE : VALUE]]
     * - VALUE = BASE IN CODE
     */
    public let rates: [String : [String : Double]]
    public let start_at: String
    public let end_at: String
    public let base: String
}

public struct LatestCurrencyExchangeInfoNetworkModel: Codable {
    let rates: [String : Double]
    let date: String
    let base: String
}
