//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 20/10/2020.
//

import Foundation

public struct CurrencyExchangeInfoNetworkModel: Codable {
    let rates: [String : [String : Double]]
    let start_at: String
    let end_at: String
    let base: String
}

