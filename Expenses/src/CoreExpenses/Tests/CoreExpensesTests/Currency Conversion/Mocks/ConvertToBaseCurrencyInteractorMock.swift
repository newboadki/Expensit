//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 21.05.2021..
//

@testable import CoreExpenses

class ConvertToBaseCurrencyInteractorMock: CurrencyConvertorInteractor {
    
    private(set) var convertAllEntriesCalled = false
    private(set) var convertAllEntriesNewBaseCurrency: String? = nil
    
    init() {}
    
    func convertAllEntries(to newBaseCurrency: String) {
        convertAllEntriesCalled = true
        convertAllEntriesNewBaseCurrency = newBaseCurrency
    }
}
