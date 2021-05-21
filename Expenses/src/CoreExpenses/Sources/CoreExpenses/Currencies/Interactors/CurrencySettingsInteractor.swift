//
//  CurrencySettingsInteractor.swift
//
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation

public protocol CurrencySettingsInteractor  {
    func currentCurrencyCode() -> String
    func previousCurrencyCode() -> String
    mutating func setPreviousCurrencyCode(_ code: String)
}
