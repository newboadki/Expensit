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
    
    private(set) var coreDataContext: NSManagedObjectContext!
    
    func generate() async throws -> NSManagedObjectContext {
        let result = await TestCoreDataStack.shared.context()
        switch result {
        case .success(let context):
            coreDataContext = context
            try await _generate()
            return context
        case .failure(let error):
            throw error
        }
    }
    
    private func _generate() async throws {
        let categoriesDataSource = CoreDataCategoryDataSource(context: coreDataContext)
        let ds = IndividualExpensesDataSource(context: coreDataContext)
        
        _ = try await categoriesDataSource.create(categories:[TestDataGenerator.Tags.food,
                                                              TestDataGenerator.Tags.bills,
                                                              TestDataGenerator.Tags.travel,
                                                              TestDataGenerator.Tags.income], save: false)
        
        let food = try await categoriesDataSource.category(for: TestDataGenerator.Tags.food);
        let bills = try await categoriesDataSource.category(for: TestDataGenerator.Tags.bills);
        let travel = try await categoriesDataSource.category(for: TestDataGenerator.Tags.travel);
        let income = try await categoriesDataSource.category(for: TestDataGenerator.Tags.income);
        
        // 2013
        
        let data1 = dateData("02/01/2013")
        let d1 = data1.0
        let c1 = data1.1
        _ = try await ds.add(expense: Expense(dateComponents: c1,
                                    date: d1,
                                    value: -15,
                                    valueInBaseCurrency: -15,
                                    description: "Breakfast",
                                    category: food,
                                    currencyCode: "GBP",
                                    exchangeRateToBaseCurrency: 1.16,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: -30,
                                    valueInBaseCurrency: -30,
                                    description: "Lunch",
                                    category: food,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 2, hour: 0, minute: 0, second: 0),
                                    date: d("02/01/2013"),
                                    value: 50,
                                    valueInBaseCurrency: 50,
                                    description: "Sarah returned some money she owed",
                                    category: income,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 30, hour: 0, minute: 0, second: 0),
                                    date: d("30/01/2013"),
                                    value: -320.9,
                                    valueInBaseCurrency: -320.9,
                                    description: "Trip to Istria",
                                    category: travel,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 31, hour: 0, minute: 0, second: 0),
                                    date: d("31/01/2013"),
                                    value: 5000,
                                    valueInBaseCurrency: 5000,
                                    description: "Salary",
                                    category: income,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 1, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/01/2013"),
                                    value: -15,
                                    valueInBaseCurrency: -15,
                                    description: "Breakfast",
                                    category: food,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 17, hour: 0, minute: 0, second: 0),
                                    date: d("17/02/2013"),
                                    value: -45,
                                    valueInBaseCurrency: -45,
                                    description: "Electricity Bills",
                                    category: bills,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 2, day: 20, hour: 0, minute: 0, second: 0),
                                    date: d("20/02/2013"),
                                    value: -90,
                                    valueInBaseCurrency: -90,
                                    description: "Night out",
                                    category: nil,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2013, month: 11, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/11/2013"),
                                    value: 500,
                                    valueInBaseCurrency: 500,
                                    description: "Salary",
                                    category: income,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        // 2014
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 3, hour: 0, minute: 0, second: 0),
                                    date: d("03/03/2014"),
                                    value: -150,
                                    valueInBaseCurrency: -150,
                                    description: "Company Lunch",
                                    category: food,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 9, hour: 0, minute: 0, second: 0),
                                    date: d("09/03/2014"),
                                    value: -11.4,
                                    valueInBaseCurrency: -11.4,
                                    description: "Lunch",
                                    category: food,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 29, hour: 0, minute: 0, second: 0),
                                    date: d("29/03/2014"),
                                    value: 3900,
                                    valueInBaseCurrency: 3900,
                                    description: "Trip to San Francisco",
                                    category: travel,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 3, day: 29, hour: 0, minute: 0, second: 0),
                                    date: d("29/03/2014"),
                                    value: -120.9,
                                    valueInBaseCurrency: -120.9,
                                    description: "Trip to the coast",
                                    category: travel,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 30, day: 09, hour: 0, minute: 0, second: 0),
                                    date: d("30/09/2014"),
                                    value: 5000,
                                    valueInBaseCurrency: 5000,
                                    description: "Salary",
                                    category: income,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 10, day: 15, hour: 0, minute: 0, second: 0),
                                    date: d("15/10/2014"),
                                    value: -45,
                                    valueInBaseCurrency: -45,
                                    description: "Internet",
                                    category: bills,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 11, day: 17, hour: 0, minute: 0, second: 0),
                                    date: d("17/11/2014"),
                                    value: -45,
                                    valueInBaseCurrency: -45,
                                    description: "Electricity Bills",
                                    category: bills,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2014, month: 12, day: 20, hour: 0, minute: 0, second: 0),
                                    date: d("20/12/2014"),
                                    value: -90,
                                    valueInBaseCurrency: -90,
                                    description: "Gas Bills",
                                    category: bills,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
        // 2015
        _ = try await ds.add(expense: Expense(dateComponents: DateComponents(year: 2015, month: 8, day: 11, hour: 0, minute: 0, second: 0),
                                    date: d("11/08/2015"),
                                    value: -163.2,
                                    valueInBaseCurrency: -163.2,
                                    description: "Trip to Motovun",
                                    category: travel,
                                    currencyCode: "USD",
                                    exchangeRateToBaseCurrency: 1,
                                    isExchangeRateUpToDate: true))
        
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
            print("DATE: \(entry.date ?? Date()), VALUE: \(entry.value), DESC: \(entry.desc ?? "-"), TAG: \(entry.tag?.name ?? "-")")
        }
        print("--------")
    }
}


private func d(_ text: String) -> Date {
    return DateConversion.date(text)
}

private func dateData(_ string: String) -> (Date, DateComponents) {
    let date = DateConversion.date(withFormat: DateFormats.defaultFormat, from: string)
    let components = DateComponents(year: date.component(.year), month: date.component(.month), day: date.component(.day), hour: date.component(.hour), minute: date.component(.minute), second: date.component(.second))
    
    return (date, components)
}

fileprivate extension DateConversion {
    static func date(_ textDate: String) -> Date {
        return DateConversion.date(withFormat:"dd/MM/yyyy", from: textDate)
    }
}
