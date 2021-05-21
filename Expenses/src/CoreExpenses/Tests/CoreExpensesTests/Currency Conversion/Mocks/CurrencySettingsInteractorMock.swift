//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 21.05.2021..
//

import Foundation
import CoreExpenses

class CurrencySettingsInteractorMock: CurrencySettingsInteractor {
    
    private let _currentCurrencyCode: String
    private let _previousCurrencyCode: String
    
    var setPreviousCurrencyCodeCalled = false
    
    // MARK: - Initializers
    
    init(currentCurrencyCode: String, previousCurrencyCode: String) {
        self._currentCurrencyCode = currentCurrencyCode
        self._previousCurrencyCode = previousCurrencyCode
    }
    
    // MARK: - CurrencySettingsInteractor
    func currentCurrencyCode() -> String {
        _currentCurrencyCode
    }
    
    func previousCurrencyCode() -> String {
        _previousCurrencyCode
    }
    
    func setPreviousCurrencyCode(_ code: String) {
        setPreviousCurrencyCodeCalled = true
    }
}
