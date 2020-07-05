//
//  IndividualExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import CoreData

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
