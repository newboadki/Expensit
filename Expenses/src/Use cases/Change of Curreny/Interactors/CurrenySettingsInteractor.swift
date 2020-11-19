//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation
import CoreExpenses

class CurrencySettingsDefaultInteractor: CurrencySettingsInteractor {
    private var dataSoure: CurrencySettingsDataSource
    
    init(dataSoure: CurrencySettingsDataSource) {
        self.dataSoure = dataSoure
    }
    
    func currentCurrencyCode() -> String {
        dataSoure.currentCurrencyCode
    }
    
    func previousCurrencyCode() -> String {
        dataSoure.previousCurrencyCode
    }

    func setPreviousCurrencyCode(_ code: String) {
        dataSoure.previousCurrencyCode = code
    }

}
