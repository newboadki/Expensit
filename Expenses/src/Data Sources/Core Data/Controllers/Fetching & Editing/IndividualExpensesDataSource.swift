//
//  IndividualExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import CoreData
import CoreExpenses

class IndividualExpensesDataSource: IndividualEntryDataSoure {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func expense(for identifier: DateComponents) -> Expense? {
        guard let first = self.entry(for: identifier) else {
            return nil
        }

        let category = ExpenseCategory(name: first.tag.name,
                                       iconName: first.tag.iconImageName,
                                       color: first.tag.color)
        
        return Expense(dateComponents: identifier,
                       date: first.date,
                       value: first.value,
                       description: first.desc,
                       category: category)
    }
    
    func saveChanges(in expense: Expense, with identifier: DateComponents) -> Result<Bool, Error> {
        guard let first = self.entry(for: identifier) else {
            return .failure(NSError(domain: "Could not save", code: -1, userInfo: nil))
        }
        
        first.date = expense.date
        first.value = expense.value
        first.desc = expense.entryDescription
        
        let request = Tag.fetchRequest()
        request.predicate = NSPredicate(format:"name LIKE %@", expense.category!.name)
        if let tags = try? context.fetch(request) as? [Tag] {
            if let firstTag = tags.first {
                first.tag = firstTag
            }
        }

        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        
        return .success(true)
    }
    
    func add(expense: Expense) -> Result<Bool, Error> {
        let managedObject = Entry.init(entity: Entry.entity(), insertInto: context)
        managedObject.value = expense.value
        managedObject.date = expense.date
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

        do {
            try context.save()
            return .success(true)
        } catch {
            return .failure(error)
        }
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
        
        let request = Entry.fetchRequest()
        request.predicate = NSPredicate(format: "(%K = %@) AND (%K = %@) AND (%K = %@) AND (%K = %@) AND (%K = %@) AND (%K = %@)",
                                        "year", NSNumber(value: y),
                                        "month", NSNumber(value: mo),
                                        "day", NSNumber(value: d),
                                        "hour", NSNumber(value: h),
                                        "minute", NSNumber(value: mi),
                                        "second", NSNumber(value: s))
        
        guard let results = try? context.fetch(request) as? [Entry] else {
            return nil
        }
        
        guard let first = results.first else {
            return nil
        }
        
        return first
    }
}
