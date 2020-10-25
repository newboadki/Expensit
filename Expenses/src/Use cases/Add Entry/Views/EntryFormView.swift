//
//  EntryFormView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses

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
            List {
                Section {
                    TextField("Amount", text: amountBinding()).foregroundColor(presenter.entry.isAmountNegative ? .red : .green)
                    
                    
                    TextField("Description", text: descBinding())
                    
                    HStack {
                        Text("Type")
                        
                        Picker(selection: entryTypeBinding(), label: Text("")) {
                            Text("Expense").tag(true)
                            Text("Income").tag(false)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }

                Section {
                    CategoryPickerView(isExpanded: isCategoryPickerExpanded,
                                       categories: presenter.categories,
                                       selectedIndex: categoryBinding())
                        .onTapGesture { self.isCategoryPickerExpanded = !self.isCategoryPickerExpanded }
                        .animation(.linear(duration: 0.3))                    
                }

                Section {
                    DatePickerView(isExpanded: isDatePickerExpanded, date: dateBinding())
                        .onTapGesture { self.isDatePickerExpanded = !self.isDatePickerExpanded }
                        .animation(.linear(duration: 0.3))
                }
                
            }.navigationBarItems(trailing:
                Button("Save") {
                    self.presenter.handleSaveButtonPressed()
                    self.$isPresented.wrappedValue = false
                }
            ).onAppear {
                self.presenter.onViewAppear()
            }
        }
    }
}

// MARKS: - Bindings
private extension EntryFormView {
    func amountBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.presenter.entry.value ?? ""
            },
            set: {
                
                let stringWithoutCurrencySymbol = $0.replacingOccurrences(of: DefaultExpenseCurrencyFormatter.amountFormatter().currencySymbol, with: "")
                let stringWithoutGroupingSeparator = stringWithoutCurrencySymbol.replacingOccurrences(of: DefaultExpenseCurrencyFormatter.amountFormatter().groupingSeparator, with: "")
                let stringWithoutDecimalSeparator = stringWithoutGroupingSeparator.replacingOccurrences(of: DefaultExpenseCurrencyFormatter.amountFormatter().decimalSeparator, with: "")
                let stringWithoutDecimalSign = stringWithoutDecimalSeparator.replacingOccurrences(of: DefaultExpenseCurrencyFormatter.amountFormatter().minusSign, with: "")

                let rawNumber = NSDecimalNumber(string:stringWithoutDecimalSign).dividing(by: NSDecimalNumber(string: "100"))
                self.presenter.entry.value = DefaultExpenseCurrencyFormatter.amountFormatter().string(from: rawNumber)
            }
        )
    }
    
    func descBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.presenter.entry.desc ?? ""
            },
            set: {
                self.presenter.entry.desc = $0
            }
        )
    }
        
    func categoryBinding() -> Binding<Int> {
        return Binding<Int>(
            get: {
                self.presenter.entry.tagId
            },
            set: {
                self.presenter.entry.tagId = $0
            }
        )
    }
        
    func dateBinding() -> Binding<Date> {
        return Binding<Date>(
            get: {
                self.presenter.entry.dateTime
            },
            set: {
                self.presenter.entry.dateTime = $0
            }
        )
    }
    
    func entryTypeBinding() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                self.presenter.entry.isAmountNegative
            },
            set: {
                self.presenter.entry.isAmountNegative = $0
            }
        )
    }
}
