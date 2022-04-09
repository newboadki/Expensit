//
//  EntryFormPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit
import Combine
import DateAndTime
import SwiftUI

public class EntryFormPresenter: ObservableObject {
        
    // MARK: - Private
    private var storageInteractor: AddExpenseInteractor
    private var categoriesInteractor: GetCategoriesInteractor
    private var getExpenseInteractor:  EntryForDateComponentsInteractor
    private var editExpenseInteractor:  EditExpenseInteractor
    private var deleteExpenseInteractor:  DeleteExpenseInteractor
    private var currencyCodesInteractor: SupportedCurrenciesInteractor
    private var exchangeRateInteractor: UpdateExpenseWithExchangeRateInteractor
    private var updateExpenseCancellable: AnyCancellable?
    
    // MARK: - Public
    public var currencyFormatter: NumberFormatter
    @Published public var entry: ExpensesSummaryEntryViewModel
    public var entryIdentifier: DateComponents?
    
    @Published
    public var categories: [String] = []
    private var categoriesCancellable = Set<AnyCancellable>()
    
    public lazy var currencyCodes: [String] = {
        self.currencyCodesInteractor.getAll()
    }()
    
    // MARK: - Initializers
    public init(storageInteractor: AddExpenseInteractor,
                categoriesInteractor: GetCategoriesInteractor,
                getExpenseInteractor:  EntryForDateComponentsInteractor,
                editExpenseInteractor:  EditExpenseInteractor,
                deleteExpenseInteractor:  DeleteExpenseInteractor,
                entryIdentifier: DateComponents? = nil,
                currencyCodesInteractor: SupportedCurrenciesInteractor,
                exchangeRateInteractor: UpdateExpenseWithExchangeRateInteractor) {
        self.entryIdentifier = entryIdentifier
        self.storageInteractor = storageInteractor
        self.getExpenseInteractor = getExpenseInteractor
        self.editExpenseInteractor = editExpenseInteractor
        self.deleteExpenseInteractor = deleteExpenseInteractor
        self.categoriesInteractor = categoriesInteractor
        self.currencyCodesInteractor = currencyCodesInteractor
        self.exchangeRateInteractor = exchangeRateInteractor
        
        let now = DateConversion.string(from: Date())
        
        currencyFormatter = NumberFormatter()
        currencyFormatter.generatesDecimalNumbers = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        let selectedCurrencyCode = self.currencyCodesInteractor.currentLocaleCurrencyCode
        
        self.entry = ExpensesSummaryEntryViewModel(id: DateComponents(),
                                                   title: "",
                                                   value: self.currencyFormatter.string(from: NSDecimalNumber(string: "0.00")),
                                                   signOfAmount: .negative,
                                                   date: now,
                                                   tag: nil,
                                                   tagId: 0,
                                                   currencyCode: selectedCurrencyCode,
                                                   currencyCodeId: self.currencyCodesInteractor.indexOfCurrentLocaleCurrencyCode)        
        self.categoriesInteractor.allCategories()
            .map({ listOfCategories in
                listOfCategories.map { $0.name }
            })
            .receive(on: RunLoop.main)
            .assign(to: \.categories, on: self)
            .store(in: &categoriesCancellable)
    }
   
    public func currencyCodeIdBinding() -> Binding<Int> {
        return Binding<Int>(
            get: {
                self.entry.currencyCodeId
            },
            set: {                
                self.entry.currencyCodeId = $0
                if let value = self.entry.value {
                    if let numberFromCurrentLocale = self.currencyFormatter.number(from: value) {
                        let newCurrencyCode = self.currencyCodes[$0]
                        self.currencyFormatter.currencyCode = newCurrencyCode
                        let stringUsingNewCode = self.currencyFormatter.string(from: numberFromCurrentLocale)
                        self.entry.value = stringUsingNewCode
                        self.entry.currencyCode = newCurrencyCode
                    }
                }
            }
        )
    }
    
    public func currencyCodeBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.currencyFormatter.currencyCode!
            },
            set: {
                $0
            }
        )
    }
    
    public func selectedCategoryName() -> String {
        guard entry.tagId < categories.count else {
            return ""
        }
        return categories[entry.tagId]
    }
        
    public func onViewAppear() {
        let selectedCurrencyCode = currencyCodesInteractor.currentLocaleCurrencyCode
        
        if let id = entryIdentifier,
           let expense = getExpenseInteractor.entry(for: id) {
                var index = 0
                if let name = expense.category?.name, let i = categories.firstIndex(of: name) {
                    index = i
                }
                
            entry = ExpensesSummaryEntryViewModel(
                id: id,
                title: expense.entryDescription,
                value: self.currencyFormatter.string(from: expense.valueInBaseCurrency),
                signOfAmount: expense.isAmountNegative,
                date: DateConversion.string(from: expense.date!),
                tag: expense.category?.name,
                tagId: index,
                dateTime: expense.date!,
                currencyCode: selectedCurrencyCode,
                currencyCodeId: self.currencyCodesInteractor.indexOfCurrentLocaleCurrencyCode)
        }
    }
    
    public func handleSaveButtonPressed(_ presentationMode: Binding<PresentationMode>) {
        entry.tag = categories[entry.tagId]
        entry.currencyCode = currencyCodes[entry.currencyCodeId]
                
        self.updateExpenseCancellable = entryEntity(fromViewModel: entry).sink { expenseEntity in
            if let id = self.entryIdentifier {
                // Editing existing entry
                Task {
                    try? await self.editExpenseInteractor.saveChanges(in: expenseEntity, with: id)
                }
            } else {
                // New Entry
                _ = self.storageInteractor.add(expense: expenseEntity)
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    public func handleDeleteButtonPressed(_ presentationMode: Binding<PresentationMode>) {
        self.updateExpenseCancellable = self.entryEntity(fromViewModel: self.entry).sink { expenseEntity in
            Task {
                try? await self.deleteExpenseInteractor.delete(expenseEntity)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func entryEntity(fromViewModel entry: ExpensesSummaryEntryViewModel) -> AnyPublisher<Expense, Never> {
        let date = entry.dateTime
        let value: NSDecimalNumber
            
        if let enteredValue = entry.value, enteredValue.count > 0 {
            if let decimalValue = self.currencyFormatter.number(from: enteredValue)?.decimalValue {
                value = NSDecimalNumber(decimal: decimalValue)
            } else {
                value = NSDecimalNumber(string: "0")
            }
        } else {
            value = NSDecimalNumber(string: "0")
        }
        
        let category = ExpenseCategory(name: entry.tag!, iconName: "", color: UIColor.white) // we only need the name to find the coredata entity later
        
        let expenseEntity = Expense(dateComponents: DateComponents(year: date.component(.year), month: date.component(.month), day: date.component(.day), hour: date.component(.hour), minute: date.component(.minute), second: date.component(.second)),
                                    date: date,
                                    value: value,
                                    valueInBaseCurrency: value,
                                    description: entry.desc,
                                    category: category,
                                    currencyCode: entry.currencyCode,
                                    exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.0"),
                                    isExchangeRateUpToDate: true)
        
        expenseEntity.identifier = nil
        
        if entry.isAmountNegative {
            if NSDecimalNumber(string: "0").compare(expenseEntity.value) == .orderedAscending {
                // Has to be negative but it's positive, then change it
                expenseEntity.value = expenseEntity.value.multiplying(by: NSDecimalNumber(string: "-1"))
                expenseEntity.valueInBaseCurrency = expenseEntity.valueInBaseCurrency.multiplying(by: NSDecimalNumber(string: "-1"))
            }
            
        } else {
            if NSDecimalNumber(string: "0").compare(expenseEntity.value) == .orderedDescending {
                // Has to be positive but it's negative, then change it
                expenseEntity.value = expenseEntity.value.multiplying(by: NSDecimalNumber(string: "-1"))
                expenseEntity.valueInBaseCurrency = expenseEntity.valueInBaseCurrency.multiplying(by: NSDecimalNumber(string: "-1"))
            }
        }
        
        return self.exchangeRateInteractor.update(expenseEntity)
    }
}


// MARKS: - Bindings
public extension EntryFormPresenter {
    
    func amountBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.entry.value ?? ""
            },
            set: {
                self.entry.value = $0
            }
        )
    }
    
    func descBinding() -> Binding<String> {
        return Binding<String>(
            get: {
                self.entry.desc ?? ""
            },
            set: {
                self.entry.desc = $0
            }
        )
    }
        
    func categoryBinding() -> Binding<Int> {
        return Binding<Int>(
            get: {
                self.entry.tagId
            },
            set: {
                self.entry.tagId = $0
            }
        )
    }
        
    func dateBinding() -> Binding<Date> {
        return Binding<Date>(
            get: {
                self.entry.dateTime
            },
            set: {
                self.entry.dateTime = $0
            }
        )
    }
    
    func entryTypeBinding() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                self.entry.isAmountNegative
            },
            set: {
                self.entry.isAmountNegative = $0
            }
        )
    }
    
    func textColorBinding() -> Binding<UIColor> {
        return Binding<UIColor>(
            get: {
                (self.entry.isAmountNegative ? #colorLiteral(red: 0.8630144, green: 0.1706678271, blue: 0.09446267039, alpha: 1) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) )
            },
            set: {
                $0
            }
        )
    }
}
