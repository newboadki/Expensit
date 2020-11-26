//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation

public class CurrencySettingsDefaultInteractor: CurrencySettingsInteractor {
    private var dataSoure: CurrencySettingsDataSource
    
    public init(dataSoure: CurrencySettingsDataSource) {
        self.dataSoure = dataSoure
    }
    
    public func currentCurrencyCode() -> String {
        dataSoure.currentCurrencyCode
    }
    
    public func previousCurrencyCode() -> String {
        dataSoure.previousCurrencyCode
    }

    public func setPreviousCurrencyCode(_ code: String) {
        dataSoure.previousCurrencyCode = code
    }

}
