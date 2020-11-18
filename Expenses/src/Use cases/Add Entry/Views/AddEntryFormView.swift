//
//  EntryFormView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses
import Currencies

struct AddEntryFormView: View {
    
    @ObservedObject private var presenter: EntryFormPresenter
    
    init(presenter: EntryFormPresenter) {
        self.presenter = presenter
    }
        
    var body: some View {
        EntryFormView().environmentObject(presenter)
    }
}

struct EditEntryFormView: View {
    
    @ObservedObject private var presenter: EntryFormPresenter
    
    init(presenter: EntryFormPresenter) {
        self.presenter = presenter
    }
        
    var body: some View {
        EntryFormView().environmentObject(presenter)
    }
}


struct EntryFormView: View {
    
    @EnvironmentObject private var presenter: EntryFormPresenter
    @State private var isCategoryPickerExpanded: Bool = false
    @State private var isDatePickerExpanded: Bool = false
    @State private var digitCount: Int = 0
    @Environment(\.presentationMode) private var presentationMode
    
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
        
    var body: some View {
                
        return List {
                            
            CurrencyTextfieldUIKitWrapper(keyboardType: .numberPad, text: presenter.amountBinding(), color:presenter.textColorBinding(), currencyFormatter: presenter.currencyFormatter)
            
            TextField("Description (Optional)", text: presenter.descBinding())
            
            HStack {
                Text("Type")
                
                Picker(selection: presenter.entryTypeBinding(), label: Text("")) {
                    Text("Expense").tag(true)
                    Text("Income").tag(false)
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            DisclosureGroup("Category: \(presenter.selectedCategoryName())") {
                Picker(selection: presenter.categoryBinding(), label: Text("")) {
                    ForEach(0..<presenter.categories.count) {
                        Text(presenter.categories[$0])
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            
            DisclosureGroup("Currency: \(presenter.currencyCodeBinding().wrappedValue)") {
                Picker(selection: presenter.currencyCodeIdBinding(), label: Text("")) {
                    ForEach(0..<presenter.currencyCodes.count) {
                        Text(presenter.currencyCodes[$0])
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            
            DatePicker("Date", selection: presenter.dateBinding())
            
            Button("Save") {
                self.presenter.handleSaveButtonPressed()
                presentationMode.wrappedValue.dismiss()

            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .foregroundColor(Color(.white))
            .background(Color(#colorLiteral(red: 0, green: 0.7931181788, blue: 0.6052855253, alpha: 1)))
            .cornerRadius(10)
            .padding(16)
        }
        .onAppear {
            self.presenter.onViewAppear()
        }
    }
}
