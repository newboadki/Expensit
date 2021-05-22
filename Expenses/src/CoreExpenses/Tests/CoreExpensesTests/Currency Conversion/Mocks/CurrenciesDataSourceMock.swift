//
//  CurrenciesDataSourceMock.swift
//  
//
//  Created by Borja Arias Drake on 22.05.2021..
//

@testable import CoreExpenses

class CurrenciesDataSourceMock: CurrenciesDataSource {
    
    var existingCurrencyCodes: [String]

    // MARK: - Initializers

    init(existingCurrencyCodes: [String]) {
        self.existingCurrencyCodes = existingCurrencyCodes
    }
    
    init() {
        self.existingCurrencyCodes = []
    }

    // MARK: - CurrenciesDataSource
    func allUsedCurrencies() -> [String] {
        existingCurrencyCodes
    }
}
