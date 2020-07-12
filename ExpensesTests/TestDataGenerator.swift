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
@testable import CoreExpenses

struct TestDataGenerator {
    
    struct Tags {
        static let food = "Food"
        static let bills = "Bills"
        static let travel = "Travel"
        static let income = "Income"
    }
    
    var coreDataContext: NSManagedObjectContext
    
    init() {
        self.coreDataContext = TestCoreDataStackHelper.coreDataContext()
    }
    
    mutating func generate() {
        
//        let container = NSPersistentContainer(name: "Expenses")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print(error)
//                // Add your error UI here
//            } else {
//                print("All seems good")
//
//            }
//        }
//        let context = container.viewContext
//        let tag = Tag.init(entity: Tag.entity(), insertInto: context)
//        tag.name = ""
//        tag.iconImageName = ""
//        tag.color = .black
//

        
        
        let categoriesDataSource = CoreDataCategoryDataSource(context: coreDataContext)
        let ds = IndividualExpensesDataSource(context: coreDataContext)
        let storeName = "expensit-test-data"
        CoreDataStackHelper.destroyAllExtensionsForSQLPersistentStoreCoordinator(withName: storeName)
        
                
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
        //ds.add(expense: ) (with: d("02/01/2013"), description: "Lunch", value: "-30.0", category: food)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: NSDecimalNumber(string: "-30.0"),
                                    description: "Lunch",
                                    category: food))
        //ds.add(expense: ) (with: d("02/01/2013"), description: "Sarah returned some money she owned", value: "50", category: income)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: NSDecimalNumber(string: "-30.0"),
                                    description: "Lunch",
                                    category: food))
        //ds.add(expense: ) (with: d("30/01/2013"), description: "Trip to Istria", value: "-320.9", category: travel)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 30, hour: 0, minute: 0, second: 0),
                                    date: d("30/01/2013"),
                                    value: NSDecimalNumber(string: "-320.9"),
                                    description: "Trip to Istria",
                                    category: travel))

        //ds.add(expense: ) (with: d("31/01/2013"), description: "Salary", value: "5000", category: income)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 31, hour: 0, minute: 0, second: 0),
                                    date: d("31/01/2013"),
                                    value: NSDecimalNumber(string: "5000"),
                                    description: "Salary",
                                    category: income))
        //coreDataController.insertNewEntry(with: d("15/02/2013"), description: "Breakfast", value: "-15.0", category: food)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/02/2013"),
                                    value: NSDecimalNumber(string: "-15.0"),
                                    description: "Breakfast",
                                    category: food))

        //coreDataController.insertNewEntry(with: d("17/02/2013"), description: "Electricity Bills", value: "-45.0", category: bills)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 17, hour: 0, minute: 0, second: 0),
                                    date: d("17/02/2013"),
                                    value: NSDecimalNumber(string: "-45.0"),
                                    description: "Electricity Bills",
                                    category: food))

        //coreDataController.insertNewEntry(with: d("20/02/2013"), description: "Night out", value: "-90.0", category: nil)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 20, hour: 0, minute: 0, second: 0),
                                    date: d("20/02/2013"),
                                    value: NSDecimalNumber(string: "-90.0"),
                                    description: "Night out",
                                    category: nil))
        //coreDataController.insertNewEntry(with: d("15/11/2013"), description: "Salary", value: "500", category: income)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 11, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/11/2013"),
                                    value: NSDecimalNumber(string: "500"),
                                    description: "Salary",
                                    category: income))

        // 2014
        //coreDataController.insertNewEntry(with: d("03/03/2014"), description: "Company Lunch", value: "-150.0", category: food)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 3, hour: 0, minute: 0, second: 0),
                                    date: d("03/03/2014"),
                                    value: NSDecimalNumber(string: "-150.0"),
                                    description: "Company Lunch",
                                    category: food))

        //coreDataController.insertNewEntry(with: d("09/03/2014"), description: "Lunch", value: "-11.4", category: food)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 9, hour: 0, minute: 0, second: 0),
                                    date: d("09/03/2014"),
                                    value: NSDecimalNumber(string: "-11.4"),
                                    description: "Lunch",
                                    category: food))

        //coreDataController.insertNewEntry(with: d("29/03/2014"), description: "Trip to San Francisco", value: "3900", category: travel)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 29, hour: 0, minute: 0, second: 0),
                                    date: d("29/03/2014"),
                                    value: NSDecimalNumber(string: "3900"),
                                    description: "Trip to San Francisco",
                                    category: travel))

        //coreDataController.insertNewEntry(with: d("29/03/2014"), description: "Trip to the coast", value: "-120.9", category: travel)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 29, day: 3, hour: 0, minute: 0, second: 0),
                                    date: d("29/03/2014"),
                                    value: NSDecimalNumber(string: "-120.9"),
                                    description: "Trip to the coast",
                                    category: travel))

        
        //coreDataController.insertNewEntry(with: d("30/09/2014"), description: "Salary", value: "5000", category: income)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 11, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/11/2013"),
                                    value: NSDecimalNumber(string: "500"),
                                    description: "Salary",
                                    category: income))

        
        //coreDataController.insertNewEntry(with: d("15/10/2014"), description: "Internet", value: "-45.0", category: bills)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 10, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/10/2014"),
                                    value: NSDecimalNumber(string: "-45.0"),
                                    description: "Internet",
                                    category: bills))

        
        //coreDataController.insertNewEntry(with: d("17/11/2014"), description: "Electricity Bills", value: "-45.0", category: bills)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 11, day: 17, hour: 0, minute: 0, second: 0),
                                    date: d("17/11/2014"),
                                    value: NSDecimalNumber(string: "-45.0"),
                                    description: "Electricity Bills",
                                    category: bills))
        
        //coreDataController.insertNewEntry(with: d("20/12/2014"), description: "Gas Bills", value: "-90.0", category: bills)
        _ = ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 12, day: 20, hour: 0, minute: 0, second: 0),
                                    date: d("20/12/2014"),
                                    value: NSDecimalNumber(string: "-90.0"),
                                    description: "Gas Bills",
                                    category: bills))


        // 2015
        //coreDataController.insertNewEntry(with: d("11/08/2015"), description: "Trip to Motovun", value: "-163.2", category: travel)
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
}

private func d(_ text: String) -> Date {
    return DateConversion.date(text)
}

fileprivate extension DateConversion {
    static func date(_ textDate: String) -> Date {
        return DateConversion.date(withFormat:"dd/MM/yyyy", from: textDate)
    }
}
