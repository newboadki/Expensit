//
//  IndividualExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import CoreData
import CoreExpenses

public class IndividualExpensesDataSource: IndividualEntryDataSoure {

    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func expense(for identifier: DateComponents) -> Expense? {
        guard let first = self.entry(for: identifier) else {
            return nil
        }

        var category: ExpenseCategory? = nil
        if let tag = first.tag {
            category = ExpenseCategory(name: tag.name,
                                       iconName: tag.iconImageName,
                                       color: tag.color)
        }
        
        return Expense(dateComponents: identifier,
                       date: first.date,
                       value: first.value,
                       valueInBaseCurrency: first.valueInBaseCurrency,
                       description: first.desc,
                       category: category,
                       currencyCode: "",
                       exchangeRateToBaseCurrency: first.exchangeRateToBaseCurrency,
                       isExchangeRateUpToDate: first.isExchangeRateUpToDate)
    }
    
    public func delete(_ expense: Expense) async throws -> Bool {
        try await context.perform {
            guard let entry = self.entry(for: expense.dateComponents) else {
                throw NSError(domain: "Could not delete entry.", code: -1, userInfo: nil)
            }
            
            self.context.delete(entry)
            try self.context.save()
            return true
        }
    }
    
    public func saveChanges(in expense: Expense, with identifier: DateComponents) async throws -> Bool {
        try await saveChanges(in: expense, with: identifier, saveToContext: true)
    }
    
    @discardableResult
    public func saveChanges(in expense: Expense, with identifier: DateComponents, saveToContext: Bool = true) async throws -> Bool {
        try await context.perform {
            guard let first = self.entry(for: identifier) else {
                throw NSError(domain: "Could not save", code: -1, userInfo: nil)
            }
            
            first.observableDate = expense.date
            first.value = expense.value
            first.valueInBaseCurrency = expense.valueInBaseCurrency
            first.exchangeRateToBaseCurrency = expense.exchangeRateToBaseCurrency
            first.isExchangeRateUpToDate = expense.isExchangeRateUpToDate
            first.currencyCode = expense.currencyCode
            first.desc = expense.entryDescription
            
            let request = Tag.tagFetchRequest()
            request.predicate = NSPredicate(format:"name LIKE %@", expense.category!.name)
            if let tags = try? self.context.fetch(request) {
                if let firstTag = tags.first {
                    first.tag = firstTag
                }
            }

            if saveToContext {
                try self.context.save()
            }
            
            return true
        }
    }
    
    public func saveChanges(in expenses: [Expense]) async throws -> Bool {
        for expense in expenses {
            try await self.saveChanges(in: expense,
                                       with: expense.dateComponents,
                                       saveToContext: false)
        }
        
        try await context.perform {
            try self.context.save()
        }
        
        return true
    }
    
    public func add(expense: Expense) -> Result<Bool, Error> {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: context)
        let managedObject = NSManagedObject(entity: description!, insertInto: context) as! Entry
        managedObject.value = expense.value
        managedObject.valueInBaseCurrency = expense.valueInBaseCurrency
        managedObject.observableDate = expense.date
        managedObject.currencyCode = expense.currencyCode
        managedObject.exchangeRateToBaseCurrency = expense.exchangeRateToBaseCurrency
        managedObject.isExchangeRateUpToDate = expense.isExchangeRateUpToDate        
                
        if let y = expense.dateComponents.year {
            managedObject.year = NSNumber(integerLiteral: y)
        }
        if let m = expense.dateComponents.month {
            managedObject.month = NSNumber(integerLiteral: m)
        }
        if let m = expense.dateComponents.day {
            managedObject.day = NSNumber(integerLiteral: m)
        }
        if let m = expense.dateComponents.hour {
            managedObject.hour = NSNumber(integerLiteral: m)
        }
        if let m = expense.dateComponents.minute {
            managedObject.minute = NSNumber(integerLiteral: m)
        }
        if let m = expense.dateComponents.second {
            managedObject.second = NSNumber(integerLiteral: m)
        }
        managedObject.desc = expense.entryDescription
        
        let fetchRequest = Tag.tagFetchRequest()
        if let theCategory = expense.category {
            fetchRequest.predicate = NSPredicate(format: "name LIKE %@", theCategory.name)
            let tag = try! self.context.fetch(fetchRequest).last!
            managedObject.tag = tag
        }

        do {
            try context.save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    public func setAllEntriesCurrenyCode(to code: String?) async throws {
        try await self.context.perform {
            let request = NSFetchRequest<Entry>(entityName: "Entry")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            let entries = try self.context.fetch(request)
            for entry in entries {
                entry.currencyCode = code ?? "USD"
                entry.exchangeRateToBaseCurrency = NSDecimalNumber(string: "1.0")
                entry.valueInBaseCurrency = entry.value
                entry.isExchangeRateUpToDate = true
            }
            try self.context.save()
        }
    }
    
    public func setDateComponentsInAllEntries() async throws {
        try await self.context.perform {
            let request = NSFetchRequest<Entry>(entityName: "Entry")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            let entries = try self.context.fetch(request)
            for entry in entries {
                if let d = entry.date {
                    entry.year = NSNumber(integerLiteral:d.component(.year))
                    entry.month = NSNumber(integerLiteral:d.component(.month))
                    entry.day = NSNumber(integerLiteral:d.component(.day))
                    entry.hour = NSNumber(integerLiteral:d.component(.hour))
                    entry.minute = NSNumber(integerLiteral:d.component(.minute))
                    entry.second = NSNumber(integerLiteral:d.component(.second))
                }
            }
            try self.context.save()
        }
    }
    
    public func setDateComponentsInAllEntries() -> Result<Bool, Error> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        if let entries = try? context.fetch(request) {
            for entry in entries {
                if let d = entry.date {
                    entry.year = NSNumber(integerLiteral:d.component(.year))
                    entry.month = NSNumber(integerLiteral:d.component(.month))
                    entry.day = NSNumber(integerLiteral:d.component(.day))
                    entry.hour = NSNumber(integerLiteral:d.component(.hour))
                    entry.minute = NSNumber(integerLiteral:d.component(.minute))
                    entry.second = NSNumber(integerLiteral:d.component(.second))
                }
            }
        }

        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        
        return .success(true)
    }
    
}

private extension IndividualExpensesDataSource {
    
    func entry(for identifier: DateComponents) -> Entry? {
        guard let y = identifier.year,
            let mo = identifier.month,
            let d = identifier.day,
            let h = identifier.hour,
            let mi = identifier.minute,
            let s = identifier.second else {
                return nil
        }
        
        let request = Entry.entryFetchRequest()
        request.predicate = NSPredicate(format: "(%K = %@) AND (%K = %@) AND (%K = %@) AND (%K = %@) AND (%K = %@) AND (%K = %@)",
                                        "year", NSNumber(value: y),
                                        "month", NSNumber(value: mo),
                                        "day", NSNumber(value: d),
                                        "hour", NSNumber(value: h),
                                        "minute", NSNumber(value: mi),
                                        "second", NSNumber(value: s))
        
        guard let results = try? context.fetch(request) else {
            return nil
        }
        
        guard let first = results.first else {
            return nil
        }
        
        return first
    }
}
