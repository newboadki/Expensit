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
    @Environment(\.presentationMode) private var presentationMode
    
    init(presenter: EntryFormPresenter) {
        self.presenter = presenter
    }
        
    var body: some View {
        NavigationView {
            EntryFormView().environmentObject(presenter)
                .navigationBarTitle("New Entry", displayMode: .inline)
                .navigationBarItems(leading:
                                        Button("Cancel") {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                        .foregroundColor(Color(#colorLiteral(red: 0.7202403275, green: 0.06977037806, blue: 0.09890884181, alpha: 1))),
                                    trailing:
                                        Button("Save") {
                                            self.presenter.handleSaveButtonPressed(self.presentationMode)
                                        }
                                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.7931181788, blue: 0.6052855253, alpha: 1)))
                )
        }
        
    }
}

struct EditEntryFormView: View {
    
    @ObservedObject private var presenter: EntryFormPresenter
    @Environment(\.presentationMode) private var presentationMode
    
    init(presenter: EntryFormPresenter) {
        self.presenter = presenter
    }
        
    var body: some View {
        EntryFormView(showDelete: true).environmentObject(presenter)
            .navigationBarItems(trailing:Button("Save") {
                self.presenter.handleSaveButtonPressed(self.presentationMode)
            }
            .foregroundColor(Color(#colorLiteral(red: 0, green: 0.7931181788, blue: 0.6052855253, alpha: 1))))
            .navigationBarTitle("Edit Entry", displayMode: .inline)
    }
}


struct EntryFormView: View {
    
    @EnvironmentObject private var presenter: EntryFormPresenter
    @State private var isCategoryPickerExpanded: Bool = false
    @State private var isDatePickerExpanded: Bool = false
    @State private var digitCount: Int = 0
    @State private var showingAlert = false
    @Environment(\.presentationMode) private var presentationMode
    private var showDelete: Bool
    
    init(showDelete: Bool = false) {
        self.showDelete = showDelete
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
            
            if self.showDelete {
                
                Button(action: {
                    self.showingAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.title)
                        Text("Delete")
                            .fontWeight(.semibold)
                            
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color(#colorLiteral(red: 0.7202403275, green: 0.06977037806, blue: 0.09890884181, alpha: 1)))
                }
                .alert(isPresented:$showingAlert) {
                    Alert(title: Text("About to Delete"), message: Text("Are you sure you want to delete this expense?"), primaryButton: .destructive(Text("Yes, Delete")) {
                        self.presenter.handleDeleteButtonPressed(self.presentationMode)                        
                    }, secondaryButton: .cancel())
                }
            }
        }
        .task {            
            await self.presenter.onViewAppear()
        }
    }
}
