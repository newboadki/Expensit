//
//  YearlyCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import CoreExpenses
import CoreData

public class YearlyCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, PerformsCoreDataRequests, CoreDataDataSource, NSFetchedResultsControllerDelegate {

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)

        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequestForYearlySummary(),
                                                                   managedObjectContext: coreDataContext,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)

        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
            self.filter(by: selectedCategory)
            self.entriesGroupedByYear { expensesGroup in
                self.groupedExpenses = expensesGroup
            }
        }                
    }
    
    public func expensesGroups(completion: @escaping ([ExpensesGroup]) -> Void) {
        self.entriesGroupedByYear { expensesGroup in
            completion(expensesGroup)
        }
    }

    private func entriesGroupedByYear(completion: @escaping ([ExpensesGroup]) -> Void) {
        self.performRequest { result in
            switch result {
                case .failure:
                    completion([ExpensesGroup]())
                
                case.success(let sections):
                    var results = [ExpensesGroup]()
                    for sectionInfo in sections!
                    {
                        var entriesForKey = [Expense]()
                        if let objects = sectionInfo.objects
                        {
                            for case let data as NSDictionary in objects
                            {
                                let date = data["date"] as! Date
                                let value = data["yearlySum"] as! NSDecimalNumber // This is an aggregation of different entries, they are already in the same currency
                                let entry = Expense(dateComponents: DateComponents(year: date.component(.year), month: nil, day: nil),
                                                    date: date,
                                                    value: value,
                                                    valueInBaseCurrency: value,
                                                    description: nil,
                                                    category: nil,
                                                    currencyCode: Locale.current.currencyCode!,
                                                    exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.0"),
                                                    isExchangeRateUpToDate: true)
                                entriesForKey.append(entry)
                            }
                        }
                        let section = ExpensesGroup(groupKey: DateComponents(), entries: entriesForKey)
                        results.append(section)
                    }
                    completion(results)
            }
        }
    }
    
    @objc func contextObjectsDidSave(_ notification: Notification) {
        self.entriesGroupedByYear { expensesGroup in
            self.groupedExpenses = expensesGroup
        }
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.entriesGroupedByYear { expensesGroup in
            self.groupedExpenses = expensesGroup
        }
    }
    
    private func fetchRequestForYearlySummary() -> NSFetchRequest<NSFetchRequestResult> {
        let baseRequest = self.baseRequest(context: coreDataContext)

        let propertiesByName = baseRequest.entity!.propertiesByName
        let yearDescription = propertiesByName["year"]
        let valueDescription = NSExpression(forKeyPath:"valueInBaseCurrency")
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [valueDescription])

        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "yearlySum"
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.expressionResultType = .decimalAttributeType

        let dateExpression = NSExpression(forKeyPath: "date")
        let minDateExpression = NSExpression(forFunction: "min:", arguments: [dateExpression])
        let minDateExpressionDescription = NSExpressionDescription()
        minDateExpressionDescription.name = "date"
        minDateExpressionDescription.expression = minDateExpression
        minDateExpressionDescription.expressionResultType = .dateAttributeType

        baseRequest.propertiesToFetch = [yearDescription!, sumExpressionDescription, minDateExpressionDescription]
        baseRequest.propertiesToGroupBy = [yearDescription!]
        baseRequest.resultType = .dictionaryResultType
        
        return baseRequest
    }
}
