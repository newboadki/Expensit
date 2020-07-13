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
        self.groupedExpenses = entriesGroupedByDay()
        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
            self.filter(by: selectedCategory)
            self.groupedExpenses = self.entriesGroupedByDay()
        }
    }
    
    private func entriesGroupedByDay() -> [ExpensesGroup] {                
        let sections = self.performRequest()
        var results = [ExpensesGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections! {
            var entriesForKey = [Expense]()
            if let objects = sectionInfo.objects {
                for case let data as NSDictionary in objects {
                    let dailySum = data["dailySum"] as! NSDecimalNumber
                    let date = data["date"] as! Date
                    let entry = Expense(dateComponents: DateComponents(year: date.component(.year), month: date.component(.month), day: date.component(.day)),
                                        date: date,
                                        value: dailySum,
                                        description: nil,
                                        category: nil)
                    entriesForKey.append(entry)
                }
            }
            
            let section = ExpensesGroup(groupKey: dateComponents(fromSectionKey: sectionInfo.name), entries: entriesForKey)
            results.append(section)
        }
        
        return results

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
        self.groupedExpenses = entriesGroupedByDay()
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = entriesGroupedByDay()
    }
    
    private func expensesByCategoryMonthlyFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let baseRequest = self.baseRequest()
        
        let propertiesByName = baseRequest.entity!.propertiesByName
        let dayMonthYearDescription = propertiesByName["dayMonthYear"]
        let dayDescription = propertiesByName["day"]
        let monthYearDescription = propertiesByName["monthYear"]
        
        let keyPathExpression = NSExpression(forKeyPath: "value")
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [keyPathExpression])
        
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
    
        baseRequest.propertiesToFetch = [monthYearDescription, dayMonthYearDescription,dayDescription, sumExpressionDescription, minDateExpressionDescription]
        baseRequest.propertiesToGroupBy = [dayMonthYearDescription, monthYearDescription, dayDescription]
        baseRequest.resultType = .dictionaryResultType
        
        return baseRequest
    }
}
