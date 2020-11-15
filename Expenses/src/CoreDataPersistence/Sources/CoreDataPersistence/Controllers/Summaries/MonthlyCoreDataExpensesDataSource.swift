//
//  MonthlyCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 26/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine
import CoreExpenses
import CoreData

public class MonthlyCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, CoreDataDataSource, PerformsCoreDataRequests, NSFetchedResultsControllerDelegate {
        
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
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequestForMonthlySummary(),
                                                                   managedObjectContext: coreDataContext,
                                                                   sectionNameKeyPath: "year",
                                                                   cacheName: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        self.groupedExpenses = entriesGroupedByMonth()
        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
            self.filter(by: selectedCategory)
            self.groupedExpenses = self.entriesGroupedByMonth()
        }
    }
    
    public func expensesGroups() -> [ExpensesGroup] {
        return self.entriesGroupedByMonth()
    }

    
    private func entriesGroupedByMonth() -> [ExpensesGroup] {
        let sections = self.performRequest()
        var results = [ExpensesGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections!
        {
            var entriesForKey = [Expense]()
            if let objects = sectionInfo.objects {
                for case let data as NSDictionary in objects {
                    let monthlySum = data["monthlySum"] as! NSDecimalNumber
                    let date = data["date"] as! Date
                    let entry = Expense(dateComponents: DateComponents(year: date.component(.year), month: date.component(.month), day: nil),
                                        date: date,
                                        value: monthlySum,
                                        valueInBaseCurrency: monthlySum,
                                        description: nil,
                                        category: nil,
                                        currencyCode: data["currencyCode"] as! String,
                                        exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.0"),
                                        isExchangeRateUpToDate: true)
                    entriesForKey.append(entry)
                }
            }
            let section = ExpensesGroup(groupKey: DateComponents(year: Int(sectionInfo.name), month: nil, day: nil), entries: entriesForKey)
            results.append(section)
        }
        
        return results
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        self.groupedExpenses = entriesGroupedByMonth()
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = entriesGroupedByMonth()
    }

    private func fetchRequestForMonthlySummary() -> NSFetchRequest<NSFetchRequestResult> {
        let baseRequest = self.baseRequest(context: coreDataContext)
        
        let propertiesByName = baseRequest.entity!.propertiesByName
        let monthDescription = propertiesByName["month"]
        let yearDescription = propertiesByName["year"]
        let currencyCodeDescription = propertiesByName["currencyCode"]        
        let valueDescription = NSExpression(forKeyPath:"valueInBaseCurrency")
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [valueDescription])
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "monthlySum"
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.expressionResultType = .decimalAttributeType
        
        let dateExpression = NSExpression(forKeyPath: "date")
        let minDateExpression = NSExpression(forFunction: "min:", arguments: [dateExpression])
        let minDateExpressionDescription = NSExpressionDescription()
        minDateExpressionDescription.name = "date"
        minDateExpressionDescription.expression = minDateExpression
        minDateExpressionDescription.expressionResultType = .dateAttributeType
        
        baseRequest.propertiesToFetch = [monthDescription, yearDescription, sumExpressionDescription, minDateExpressionDescription, currencyCodeDescription]
        baseRequest.propertiesToGroupBy = [monthDescription, yearDescription, currencyCodeDescription]
        baseRequest.resultType = .dictionaryResultType
        
        return baseRequest
    }
}
