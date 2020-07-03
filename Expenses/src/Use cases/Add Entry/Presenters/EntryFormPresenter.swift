//
//  EntryFormPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class EntryFormPresenter: ObservableObject {
    
    @Published var entry: ExpensesSummaryEntryViewModel
    
    private var storageInteractor: BSAddEntryController
    private var categoriesInteractor: GetCategoriesInteractor
    private var getExpenseInteractor:  EntryForDateIdentifierInteractor
    
    var entryIdentifier: DateIdentifier?
    
    lazy var categories: [String] = {
        self.categoriesInteractor.allCategories().map { expenseCategory in
            return expenseCategory.name
        }
    }()
    
    init(storageInteractor: BSAddEntryController,
         categoriesInteractor: GetCategoriesInteractor,
         getExpenseInteractor:  EntryForDateIdentifierInteractor,
         entryIdentifier: DateIdentifier? = nil) {
        self.entryIdentifier = entryIdentifier
        self.storageInteractor = storageInteractor
        self.getExpenseInteractor = getExpenseInteractor
        self.categoriesInteractor = categoriesInteractor
        let now = DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: Date())
        self.entry = ExpensesSummaryEntryViewModel(id: DateIdentifier(),
                                                   title: "",
                                                   value: "",
                                                   signOfAmount: .negative,
                                                   date: now,
                                                   tag: nil,
                                                   tagId: 0)
        
        if let id = entryIdentifier,
           let expense = self.getExpenseInteractor.entry(for: id) {
            var index = 0
            if let name = expense.category?.name, let i = self.categories.firstIndex(of: name) {
                index = i
            }
            self.entry = ExpensesSummaryEntryViewModel(id: id,
                                                       title: expense.entryDescription,
                                                       value: "\(expense.value)",
                                                       signOfAmount: .negative,
                                                       date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: expense.date),
                                                       tag: expense.category?.name,
                                                       tagId: index)
        }
    }
    
    func handleSaveButtonPressed() {
        self.entry.tag = categories[self.entry.tagId]
        let entity = entryEntity(fromViewModel: self.entry)
        self.storageInteractor.save(entry: entity, successBlock: {
            print("Entry saved successfully.")
        }) { error in
            print("Entry couldn't be saved due to \(error).")
        }
    }
    
    private func entryEntity(fromViewModel entry: ExpensesSummaryEntryViewModel) -> Expense {
        let date = entry.dateTime //DateTimeHelper.date(withFormat: DEFAULT_DATE_FORMAT, stringDate: entry.date)
        let value: NSDecimalNumber
            
        if let enteredValue = entry.value, enteredValue.count > 0 {
            if let decimalValue = BSCurrencyHelper.amountFormatter().number(from: enteredValue)?.decimalValue {
                value = NSDecimalNumber(decimal: decimalValue)
            } else {
                value = NSDecimalNumber(string: "0")
            }
        } else {
            value = NSDecimalNumber(string: "0")
        }
        let category = ExpenseCategory(name: entry.tag!, iconName: "", color: UIColor.white) // we only need the name to find the coredata entity later
        let entity = Expense(dateIdentifier: DateIdentifier(year: date.component(.year), month: date.component(.month), day: date.component(.day)), date: date, value:value, description: entry.desc, category: category)
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
