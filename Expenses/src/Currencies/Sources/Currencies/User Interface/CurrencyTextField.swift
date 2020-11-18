//
//  CurrencyTextField.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 9/8/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit
import SwiftUI

public class CurrencyTextField: UITextField {
    
    var passTextFieldText: ((String, Double?) -> Void)?
    private var textBinding: Binding<String>?
    public var currencyFormatter: NumberFormatter? {
        didSet {
            updateTextField(notifyChange: false)
        }
    }
    
    /// Used to send clean double value back
    private var amountAsDouble: Double?
    
    private var startingValue: Double? {
        didSet {
            let nsNumber = NSNumber(value: startingValue ?? 0.0)
            self.text = defaultNumberFormatter.string(from: nsNumber)
        }
    }
    
    private var formatter: NumberFormatter {
        currencyFormatter ?? defaultNumberFormatter
    }
    
    private lazy var defaultNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // Locale and currencyCode set in currency property observer
        return formatter
    }()
    
    private var roundingPlaces: Int {
        return self.formatter.maximumFractionDigits
    }
    
    private var isSymbolOnRight = false
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //If using in SBs
        setup()
    }
    
    // MARK: - Helpers
    
    private func setup() {
        self.textAlignment = .right
        self.keyboardType = .numberPad
        self.contentScaleFactor = 0.5
        delegate = self
        
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    //AFTER entered string is registered in the textField
    @objc private func textFieldDidChange() {
        updateTextField()
    }
    
    //Placed in separate method so when the user selects an account with a different currency, it will immediately be reflected
    private func updateTextField(notifyChange: Bool = true) {
        var cleanedAmount = ""
        
        for character in self.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        //Format the number based on number of decimal digits
        if self.roundingPlaces > 0 {
            //ie. USD
            let amount = Double(cleanedAmount) ?? 0.0
            amountAsDouble = (amount / 100.0)
            let amountAsString = self.formatter.string(from: NSNumber(value: amountAsDouble ?? 0.0)) ?? ""
            
            self.text = amountAsString
        } else {
            //ie. JPY
            let amountAsNumber = Double(cleanedAmount) ?? 0.0
            amountAsDouble = amountAsNumber
            self.text = self.formatter.string(from: NSNumber(value: amountAsNumber)) ?? ""
        }
        
        if notifyChange {
            passTextFieldText?(self.text!, amountAsDouble)
        }
        
    }
    
    //Prevents the user from moving the cursor in the textField
    //Source: https://stackoverflow.com/questions/16419095/prevent-user-from-setting-cursor-position-on-uitextfield
    public override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
    
}


extension CurrencyTextField: UITextFieldDelegate {
    
    //BEFORE entered string is registered in the textField
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastCharacterInTextField = (textField.text ?? "").last
        
        //Note - not the most straight forward implementation but this subclass supports both right and left currencies
        if string == "" && lastCharacterInTextField!.isNumber == false {
            //For hitting backspace and currency is on the right side
            isSymbolOnRight = true
        } else {
            isSymbolOnRight = false
        }
        
        return true
    }
}
