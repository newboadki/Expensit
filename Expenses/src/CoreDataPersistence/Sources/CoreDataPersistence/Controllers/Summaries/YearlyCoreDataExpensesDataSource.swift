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
            self.groupedExpenses = self.entriesGroupedByYear()
        }                
    }
    
    private func entriesGroupedByYear() -> [ExpensesGroup]
    {
        let sections = self.performRequest()
        var results = [ExpensesGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections!
        {
            var entriesForKey = [Expense]()
            if let objects = sectionInfo.objects
            {
                for case let data as NSDictionary in objects
                {
                    let yearlySum = data["yearlySum"] as! NSDecimalNumber
                    let date = data["date"] as! Date
                    let entry = Expense(dateComponents: DateComponents(year: date.component(.year), month: nil, day: nil),
                                        date: date,
                                        value: yearlySum,
                                        description: nil,
                                        category: nil)
                    entriesForKey.append(entry)
                }
            }
            let section = ExpensesGroup(groupKey: DateComponents(), entries: entriesForKey)
            results.append(section)
        }
        
        return results
    }
    
    @objc func contextObjectsDidSave(_ notification: Notification) {
        self.groupedExpenses = self.entriesGroupedByYear()
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = entriesGroupedByYear()
    }
    
    private func fetchRequestForYearlySummary() -> NSFetchRequest<NSFetchRequestResult> {
        let baseRequest = self.baseRequest(context: coreDataContext)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        baseRequest.sortDescriptors = [sortDescriptor]

        let propertiesByName = baseRequest.entity!.propertiesByName
        let yearDescription = propertiesByName["year"]
        let keyPathExpression = NSExpression(forKeyPath: "value")
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [keyPathExpression])

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
