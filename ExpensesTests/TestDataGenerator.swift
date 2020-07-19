//
//  TestDataGenerator.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 28/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation
import DateAndTime
import CoreData
import CoreDataPersistence
import CoreExpenses

class TestDataGenerator {
    
    struct Tags {
        static let food = "Food"
        static let bills = "Bills"
        static let travel = "Travel"
        static let income = "Income"
    }
    
    var coreDataContext: NSManagedObjectContext!
    

    
    init() {        
    }
    
    func generate(_  completion: @escaping(Result<NSManagedObjectContext, Error>)->() ) {
        TestCoreDataStack.context { [weak self] result in
            switch result {
                case .failure(let coreDataError):
                    print(coreDataError)
                case .success(let context):
                    self?.coreDataContext = context
                    self?._generate()
                    completion(.success(context))
            }
        }
    }
    
    func generate_sync() -> NSManagedObjectContext {
        coreDataContext = TestCoreDataStack.context_sync()
        _generate()
        return coreDataContext
    }
    
    private func _generate() {
        let categoriesDataSource = CoreDataCategoryDataSource(context: coreDataContext)
        let ds = IndividualExpensesDataSource(context: coreDataContext)
                        
        _ = categoriesDataSource.create(categories:[TestDataGenerator.Tags.food,
                                                    TestDataGenerator.Tags.bills,
                                                    TestDataGenerator.Tags.travel,
                                                    TestDataGenerator.Tags.income])
        
        let food = categoriesDataSource.category(for: TestDataGenerator.Tags.food);
        let bills = categoriesDataSource.category(for: TestDataGenerator.Tags.bills);
        let travel = categoriesDataSource.category(for: TestDataGenerator.Tags.travel);
        let income = categoriesDataSource.category(for: TestDataGenerator.Tags.income);
        
        // 2013
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: NSDecimalNumber(string: "-15.0"),
                                    description: "Breakfast",
                                    category: food))
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: NSDecimalNumber(string: "-30.0"),
                                    description: "Lunch",
                                    category: food))
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: NSDecimalNumber(string: "50.0"),
                                    description: "Sarah returned some money she owed",
                                    category: income))
        
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 30, hour: 0, minute: 0, second: 0),
                                    date: d("30/01/2013"),
                                    value: NSDecimalNumber(string: "-320.9"),
                                    description: "Trip to Istria",
                                    category: travel))

        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 31, hour: 0, minute: 0, second: 0),
                                    date: d("31/01/2013"),
                                    value: NSDecimalNumber(string: "5000"),
                                    description: "Salary",
                                    category: income))
        
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/02/2013"),
                                    value: NSDecimalNumber(string: "-15.0"),
                                    description: "Breakfast",
                                    category: food))

        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 17, hour: 0, minute: 0, second: 0),
                                    date: d("17/02/2013"),
                                    value: NSDecimalNumber(string: "-45.0"),
                                    description: "Electricity Bills",
                                    category: bills))

        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 20, hour: 0, minute: 0, second: 0),
                                    date: d("20/02/2013"),
                                    value: NSDecimalNumber(string: "-90.0"),
                                    description: "Night out",
                                    category: nil))
        
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 11, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/11/2013"),
                                    value: NSDecimalNumber(string: "500"),
                                    description: "Salary",
                                    category: income))

        // 2014
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 3, hour: 0, minute: 0, second: 0),
                                    date: d("03/03/2014"),
                                    value: NSDecimalNumber(string: "-150.0"),
                                    description: "Company Lunch",
                                    category: food))
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 9, hour: 0, minute: 0, second: 0),
                                    date: d("09/03/2014"),
                                    value: NSDecimalNumber(string: "-11.4"),
                                    description: "Lunch",
                                    category: food))

        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 29, hour: 0, minute: 0, second: 0),
                                    date: d("29/03/2014"),
                                    value: NSDecimalNumber(string: "3900"),
                                    description: "Trip to San Francisco",
                                    category: travel))

        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 29, hour: 0, minute: 0, second: 0),
                                    date: d("29/03/2014"),
                                    value: NSDecimalNumber(string: "-120.9"),
                                    description: "Trip to the coast",
                                    category: travel))

        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 30, day: 09, hour: 0, minute: 0, second: 0),
                                    date: d("30/09/2014"),
                                    value: NSDecimalNumber(string: "5000"),
                                    description: "Salary",
                                    category: income))

        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 10, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/10/2014"),
                                    value: NSDecimalNumber(string: "-45.0"),
                                    description: "Internet",
                                    category: bills))

        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 11, day: 17, hour: 0, minute: 0, second: 0),
                                    date: d("17/11/2014"),
                                    value: NSDecimalNumber(string: "-45.0"),
                                    description: "Electricity Bills",
                                    category: bills))
        
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 12, day: 20, hour: 0, minute: 0, second: 0),
                                    date: d("20/12/2014"),
                                    value: NSDecimalNumber(string: "-90.0"),
                                    description: "Gas Bills",
                                    category: bills))

        // 2015
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2015, month: 8, day: 11, hour: 0, minute: 0, second: 0),
                                    date: d("11/08/2015"),
                                    value: NSDecimalNumber(string: "-163.2"),
                                    description: "Trip to Motovun",
                                    category: travel))

        /*
        Yearly summary:
        - No filter
        - Food Filter
        - Bills
        - Travel
        - Income
     
         Monthly summary:
         - No filter
         - Food Filter
         - Bills
         - Travel
         - Income
         
         Daily summary:
         - No filter
         - Food Filter
         - Bills
         - Travel
         - Income

         All entries summary:
         - No filter
         - Food Filter
         - Bills
         - Travel
         - Income

         */
    }
    
    static func printAll(_ coreDataContext: NSManagedObjectContext) {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: coreDataContext)
        let request = Entry.entryFetchRequest()
        request.entity = description
        request.fetchBatchSize = 50
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]        
        let entries = try! coreDataContext.fetch(request)
        for entry in entries {
            print("DATE: \(entry.date), VALUE: \(entry.value), DESC: \(entry.desc ?? "-"), TAG: \(entry.tag?.name ?? "-")")
        }
        print("--------")
    }
}
 

private func d(_ text: String) -> Date {
    return DateConversion.date(text)
}

fileprivate extension DateConversion {
    static func date(_ textDate: String) -> Date {
        return DateConversion.date(withFormat:"dd/MM/yyyy", from: textDate)
    }
}
