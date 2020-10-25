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

public class EntryFormPresenter: ObservableObject {
        
    // MARK: - Private
    private var storageInteractor: AddExpenseInteractor
    private var categoriesInteractor: GetCategoriesInteractor
    private var getExpenseInteractor:  EntryForDateComponentsInteractor
    private var editExpenseInteractor:  EditExpenseInteractor
    
    // MARK: - Internal
    @Published public var entry: ExpensesSummaryEntryViewModel
    public var entryIdentifier: DateComponents?
    public lazy var categories: [String] = {
        self.categoriesInteractor.allCategories().map { expenseCategory in
            return expenseCategory.name
        }
    }()
    
    // MARK: - Initializers
    public init(storageInteractor: AddExpenseInteractor,
                categoriesInteractor: GetCategoriesInteractor,
                getExpenseInteractor:  EntryForDateComponentsInteractor,
                editExpenseInteractor:  EditExpenseInteractor,
                entryIdentifier: DateComponents? = nil) {
        self.entryIdentifier = entryIdentifier
        self.storageInteractor = storageInteractor
        self.getExpenseInteractor = getExpenseInteractor
        self.editExpenseInteractor = editExpenseInteractor
        self.categoriesInteractor = categoriesInteractor
        let now = DateConversion.string(from: Date())
        self.entry = ExpensesSummaryEntryViewModel(id: DateComponents(),
                                                   title: "",
                                                   value: DefaultExpenseCurrencyFormatter.amountFormatter().string(from: NSDecimalNumber(string: "0.00")),
                                                   signOfAmount: .negative,
                                                   date: now,
                                                   tag: nil,
                                                   tagId: 0,
                                                   currencyCode: NSLocale.current.currencySymbol ?? "$")
        
        // This should be in onViewAppear, but the presenter is currently getting initiallized twice from the entry form.
        DispatchQueue.global().async {
            if let id = self.entryIdentifier,
               let expense = self.getExpenseInteractor.entry(for: id) {
                var index = 0
                if let name = expense.category?.name, let i = self.categories.firstIndex(of: name) {
                    index = i
                }
                DispatchQueue.main.async {
                    self.entry = ExpensesSummaryEntryViewModel(id: id,
                                                               title: expense.entryDescription,
                                                               value: DefaultExpenseCurrencyFormatter.amountFormatter().string(from: expense.value),
                                                               signOfAmount: expense.isAmountNegative,
                                                               date: DateConversion.string(from: expense.date!),
                                                               tag: expense.category?.name,
                                                               tagId: index,
                                                               dateTime: expense.date!,
                                                               currencyCode: NSLocale.current.currencySymbol ?? "$")
                }
            }
        }
    }
    
    public func onViewAppear() {
    }
    
    public func handleSaveButtonPressed() {
        
        self.entry.tag = self.categories[self.entry.tagId]
        
        DispatchQueue.global().async {
            
            let entity = self.entryEntity(fromViewModel: self.entry)

            if let id = self.entryIdentifier {
                // Editing existing entry
                _ = self.editExpenseInteractor.saveChanges(in: entity, with: id)
            } else {
                // New Entry
                _ = self.storageInteractor.add(expense: entity)
            }
        }
    }
    
    private func entryEntity(fromViewModel entry: ExpensesSummaryEntryViewModel) -> Expense {
        let date = entry.dateTime
        let value: NSDecimalNumber
            
        if let enteredValue = entry.value, enteredValue.count > 0 {
            if let decimalValue = DefaultExpenseCurrencyFormatter.amountFormatter().number(from: enteredValue)?.decimalValue {
                value = NSDecimalNumber(decimal: decimalValue)
            } else {
                value = NSDecimalNumber(string: "0")
            }
        } else {
            value = NSDecimalNumber(string: "0")
        }
        let category = ExpenseCategory(name: entry.tag!, iconName: "", color: UIColor.white) // we only need the name to find the coredata entity later
        let entity = Expense(dateComponents: DateComponents(year: date.component(.year), month: date.component(.month), day: date.component(.day)), date: date, value:value, description: entry.desc, category: category, currencyCode: entry.currencyCode, exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.0"))
        entity.identifier = nil
        if entry.isAmountNegative {
            if NSDecimalNumber(string: "0").compare(entity.value) == .orderedAscending {
                // Has to be negative but it's positive, then change it
                entity.value = entity.value.multiplying(by: NSDecimalNumber(string: "-1"))
            }
            
        } else {
            if NSDecimalNumber(string: "0").compare(entity.value) == .orderedDescending {
                // Has to be positive but it's negative, then change it
                entity.value = entity.value.multiplying(by: NSDecimalNumber(string: "-1"))
            }
        }
        return entity
    }
}
