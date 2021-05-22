//
//  CurrenciesDataSource.swift
//  
//
//  Created by Borja Arias Drake on 22.05.2021..
//

import Foundation

public protocol CurrenciesDataSource {
    func allUsedCurrencies() -> [String]
}
