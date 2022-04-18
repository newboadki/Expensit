//
//  DailyCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine
import CoreExpenses
import CoreData

public class DailyCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, CoreDataDataSource, PerformsCoreDataRequests, NSFetchedResultsControllerDelegate {
    
    @Published public var groupedExpenses = [ExpensesGroup]()
    public var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    public var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
        
    private(set) public var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private(set) public var coreDataContext: NSManagedObjectContext
    private var selectedCategoryDataSource: CategoryDataSource
    private var cancellableSelectedCategoryUpdates: AnyCancellable?
    
    public init(coreDataContext: NSManagedObjectContext,
                selectedCategoryDataSource: CategoryDataSource) {
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        super.init()
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.expensesByCategoryMonthlyFetchRequest(), managedObjectContext: coreDataContext,
                                                                   sectionNameKeyPath: "monthYear", cacheName: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        self.groupedExpenses = [ExpensesGroup]()
        entriesGroupedByDay {expensesGroups in
            self.groupedExpenses = expensesGroups
        }
        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
                self.filter(by: selectedCategory)
            
                self.entriesGroupedByDay { expensesGroups in
                    self.groupedExpenses = expensesGroups
                }
        }
    }
    
    public func expensesGroups(completion: @escaping ([ExpensesGroup]) -> Void) {
        entriesGroupedByDay {expensesGroups in
            completion(expensesGroups)
        }
    }

    
    private func entriesGroupedByDay(completion: @escaping ([ExpensesGroup]) -> Void) {
        
        self.performRequest { result in
            switch result {
                case .failure:
                    completion([ExpensesGroup]())
                
                case.success(let sections):
                    var results = [ExpensesGroup]()
                    for sectionInfo in sections! {
                        var entriesForKey = [Expense]()
                        if let objects = sectionInfo.objects {
                            for case let data as NSDictionary in objects {
                                let dailySum = data["dailySum"] as! NSDecimalNumber
                                let date = data["date"] as! Date
                                let entry = Expense(dateComponents: DateComponents(year: date.component(.year), month: date.component(.month), day: date.component(.day)),
                                                    date: date,
                                                    value: dailySum,
                                                    valueInBaseCurrency: dailySum,
                                                    description: nil,
                                                    category: nil,
                                                    currencyCode: "",
                                                    exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.0"),
                                                    isExchangeRateUpToDate: true)
                                entriesForKey.append(entry)
                            }
                        }
                        
                        let section = ExpensesGroup(groupKey: self.dateComponents(fromSectionKey: sectionInfo.name), entries: entriesForKey)
                        results.append(section)
                    }
                completion(results)
            }
        }
    }
    
    private func dateComponents(fromSectionKey key: String) -> DateComponents {
        let components = key.components(separatedBy: "/")
        var year: Int? = nil
        var month: Int? = nil

        if let d = components.first,
            let n = Int(d) {
            month = n
        }
        
        if components.count >= 2 {
            year = Int(components[1])
        }
        
        return DateComponents(year: year, month: month, day: nil)
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        entriesGroupedByDay { expensesGroups in
            self.groupedExpenses = expensesGroups
        }
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        entriesGroupedByDay { expensesGroups in
            self.groupedExpenses = expensesGroups
        }
    }
    
    private func expensesByCategoryMonthlyFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let baseRequest = self.baseRequest(context: coreDataContext)
        
        let propertiesByName = baseRequest.entity!.propertiesByName
        let dayMonthYearDescription = propertiesByName["dayMonthYear"]
        let dayDescription = propertiesByName["day"]
        let monthYearDescription = propertiesByName["monthYear"]
        let currencyCodeDescription = propertiesByName["currencyCode"]
        
        let valueDescription = NSExpression(forKeyPath:"valueInBaseCurrency")
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [valueDescription])
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "dailySum"
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.expressionResultType = .decimalAttributeType
        
        let dateExpression = NSExpression(forKeyPath: "date")
        let minDateExpression = NSExpression(forFunction: "min:", arguments: [dateExpression])
        let minDateExpressionDescription = NSExpressionDescription()
        minDateExpressionDescription.name = "date"
        minDateExpressionDescription.expression = minDateExpression
        minDateExpressionDescription.expressionResultType = .dateAttributeType
    
        baseRequest.propertiesToFetch = [monthYearDescription, dayMonthYearDescription,dayDescription, sumExpressionDescription, minDateExpressionDescription, currencyCodeDescription]
        baseRequest.propertiesToGroupBy = [dayMonthYearDescription, monthYearDescription, dayDescription, currencyCodeDescription]
        baseRequest.resultType = .dictionaryResultType
        
        return baseRequest
    }
}
