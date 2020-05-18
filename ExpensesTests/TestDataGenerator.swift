//
//  TestDataGenerator.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 28/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation


struct TestDataGenerator {
    
    struct Tags {
        static let food = "Food"
        static let bills = "Bills"
        static let travel = "Travel"
        static let income = "Income"
    }
    
    func generate() {
        let storeName = "expensit-test-data"
        CoreDataStackHelper.destroyAllExtensionsForSQLPersistentStoreCoordinator(withName: storeName)
        let coreDataController = TestCoreDataStackHelper.coreDataController()
                
        coreDataController.createTags([TestDataGenerator.Tags.food, TestDataGenerator.Tags.bills, TestDataGenerator.Tags.travel])
        let food = coreDataController.tag(forName: TestDataGenerator.Tags.food);
        let bills = coreDataController.tag(forName: TestDataGenerator.Tags.bills);
        let travel = coreDataController.tag(forName: TestDataGenerator.Tags.travel);
        let income = coreDataController.tag(forName: TestDataGenerator.Tags.income);
        
        // 2013
        coreDataController.insertNewEntry(with: d("02/01/2013"), description: "Breakfast", value: "-15.0", category: food)
        coreDataController.insertNewEntry(with: d("02/01/2013"), description: "Lunch", value: "-30.0", category: food)
        coreDataController.insertNewEntry(with: d("02/01/2013"), description: "Sarah returned some money she owned", value: "50", category: income)
        coreDataController.insertNewEntry(with: d("30/01/2013"), description: "Trip to Istria", value: "-320.9", category: travel)
        coreDataController.insertNewEntry(with: d("31/01/2013"), description: "Salary", value: "5000", category: income)
        coreDataController.insertNewEntry(with: d("15/02/2013"), description: "Breakfast", value: "-15.0", category: food)
        coreDataController.insertNewEntry(with: d("17/02/2013"), description: "Electricity Bills", value: "-45.0", category: bills)
        coreDataController.insertNewEntry(with: d("20/02/2013"), description: "Night out", value: "-90.0", category: nil)
        coreDataController.insertNewEntry(with: d("15/11/2013"), description: "Salary", value: "500", category: income)

        // 2014
        coreDataController.insertNewEntry(with: d("03/03/2014"), description: "Company Lunch", value: "-150.0", category: food)
        coreDataController.insertNewEntry(with: d("09/03/2014"), description: "Lunch", value: "-11.4", category: food)
        coreDataController.insertNewEntry(with: d("29/03/2014"), description: "Trip to San Francisco", value: "3900", category: travel)
        coreDataController.insertNewEntry(with: d("29/03/2014"), description: "Trip to the coast", value: "-120.9", category: travel)
        coreDataController.insertNewEntry(with: d("31/09/2014"), description: "Salary", value: "5000", category: income)
        coreDataController.insertNewEntry(with: d("15/10/2014"), description: "Internet", value: "-45.0", category: bills)
        coreDataController.insertNewEntry(with: d("17/11/2014"), description: "Electricity Bills", value: "-45.0", category: bills)
        coreDataController.insertNewEntry(with: d("20/12/2014"), description: "Gas Bills", value: "-90.0", category: bills)

        
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
    return DateTimeHelper.date(text)
}

fileprivate extension DateTimeHelper {
    static func date(_ textDate: String) -> Date {
        return DateTimeHelper.date(withFormat:nil, stringDate: textDate)
    }
}
