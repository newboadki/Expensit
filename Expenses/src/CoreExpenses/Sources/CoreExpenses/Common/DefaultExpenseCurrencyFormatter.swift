//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 08/07/2020.
//

import Foundation

public struct DefaultExpenseCurrencyFormatter {
 
    private static var _amountFormatter: NumberFormatter? = nil
    
    public static func amountFormatter() -> NumberFormatter {
        if _amountFormatter == nil {
            _amountFormatter = NumberFormatter()
            _amountFormatter!.generatesDecimalNumbers = true
            _amountFormatter!.numberStyle = .currency
            _amountFormatter!.locale = NSLocale.current
        }
        
        return _amountFormatter!
    }
}
