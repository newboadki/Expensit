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

struct EntryFormView: View {
    
    @ObservedObject private var presenter: EntryFormPresenter
    @State var isCategoryPickerExpanded: Bool = false
    @State var isDatePickerExpanded: Bool = false
    @Binding var isPresented: Bool
    @State var digitCount: Int = 0

    
    init(presenter: EntryFormPresenter, beingPresented: Binding<Bool>) {
        self.presenter = presenter
        self._isPresented = beingPresented
        UITableView.appearance().separatorStyle = .none
    }
        
    var body: some View {
                
        return NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Add Entry")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    Spacer()
                }
                
                List {
                    
                    Group {
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
                            }
                        }
                        
                        DisclosureGroup("Currency: \(presenter.currencyCodeBinding().wrappedValue)") {
                            Picker(selection: presenter.currencyCodeIdBinding(), label: Text("")) {
                                ForEach(0..<presenter.currencyCodes.count) {
                                    Text(presenter.currencyCodes[$0])
                                }
                            }
                        }
                        
                        DatePicker("Date", selection: presenter.dateBinding())
                    }
            }
                
            Spacer()
                

            Button("Save") {
                self.presenter.handleSaveButtonPressed()
                self.$isPresented.wrappedValue = false

            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .foregroundColor(Color(.white))
            .background(Color(#colorLiteral(red: 0, green: 0.7931181788, blue: 0.6052855253, alpha: 1)))
            .cornerRadius(10)
            .padding(16)



                
            }.onAppear {
                self.presenter.onViewAppear()
            }
        }
    }
}


struct EditEntryFormView: View {
    
    @ObservedObject private var presenter: EditEntryFormPresenter
    @State var isCategoryPickerExpanded: Bool = false
    @State var isDatePickerExpanded: Bool = false
    @Binding var isPresented: Bool
    @State var digitCount: Int = 0

    
    init(presenter: EditEntryFormPresenter, beingPresented: Binding<Bool>) {
        self.presenter = presenter
        self._isPresented = beingPresented
        UITableView.appearance().separatorStyle = .none
    }
        
    var body: some View {
                
        return NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Add Entry")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    Spacer()
                }
                
                List {
                    
                    Group {
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
                            }
                        }
                        
                        DisclosureGroup("Currency: \(presenter.currencyCodeBinding().wrappedValue)") {
                            Picker(selection: presenter.currencyCodeIdBinding(), label: Text("")) {
                                ForEach(0..<presenter.currencyCodes.count) {
                                    Text(presenter.currencyCodes[$0])
                                }
                            }
                        }
                        
                        DatePicker("Date", selection: presenter.dateBinding())
                    }
            }
                
            Spacer()
                

            Button("Save") {
                self.presenter.handleSaveButtonPressed()
                self.$isPresented.wrappedValue = false

            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .foregroundColor(Color(.white))
            .background(Color(#colorLiteral(red: 0, green: 0.7931181788, blue: 0.6052855253, alpha: 1)))
            .cornerRadius(10)
            .padding(16)



                
            }.onAppear {
                self.presenter.onViewAppear()
            }
        }
    }
}

