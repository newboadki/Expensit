//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 21.05.2021..
//

import Foundation

public protocol CurrencyConvertorInteractor {
    func convertAllEntries(to newBaseCurrency: String)
}
