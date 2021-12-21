//
//  CurrencyTextfieldWrapper.swift
//  adfasdfsdf
//
//  Created by Borja Arias Drake on 28/10/2020.
//

import SwiftUI


public struct CurrencyTextfieldUIKitWrapper: UIViewRepresentable {
    
    public let keyboardType: UIKeyboardType
    @Binding public var text: String
    @Binding public var textColor: UIColor    
    public var currencyFormatter: NumberFormatter
    
    public init(keyboardType: UIKeyboardType, text: Binding<String>, color: Binding<UIColor>, currencyFormatter: NumberFormatter) {
        self.keyboardType = keyboardType
        self._text = text
        self._textColor = color
        self.currencyFormatter = currencyFormatter
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = CurrencyTextField()
        textField.currencyFormatter = self.currencyFormatter
        textField.frame = .zero  // Will use auto-layout
        textField.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        textField.textAlignment = .left
        textField.textColor = self.textColor
        textField.placeholder = "0.00"
        textField.passTextFieldText = { (string, number) in
            context.coordinator.handle(string)
        }
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.textColor = textColor
        uiView.text = text
        if let ctf = uiView as? CurrencyTextField {
            ctf.currencyFormatter = self.currencyFormatter
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(textBinding: self.$text)
    }
    
    public class Coordinator: NSObject {
        
        @Binding public var text: String

        init(textBinding: Binding<String>) {
            self._text = textBinding
        }
        
        public func handle(_ text: String) {
            self.text = text
        }
    }
}


