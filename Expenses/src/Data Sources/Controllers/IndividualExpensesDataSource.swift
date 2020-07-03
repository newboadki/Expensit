//
//  IndividualExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import CoreData

class IndividualExpensesDataSource {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func expense(for identifier: DateIdentifier) -> Expense? {
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

        let category = ExpenseCategory(name: first.tag.name,
                                       iconName: first.tag.iconImageName,
                                       color: first.tag.color)
        
        return Expense(dateIdentifier: identifier,
                       date: first.date,
                       value: first.value,
                       description: first.desc,
                       category: category)
    }
}
