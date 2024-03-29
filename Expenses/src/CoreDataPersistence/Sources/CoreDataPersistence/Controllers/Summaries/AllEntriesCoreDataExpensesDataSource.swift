//
//  AllEntriesCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import UIKit
import Combine
import CoreExpenses
import CoreData

public class AllEntriesCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, CoreDataDataSource, PerformsCoreDataRequests, NSFetchedResultsControllerDelegate {
    
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
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequestForIndividualEntriesSummary(),
                                                                   managedObjectContext: coreDataContext,
                                                                   sectionNameKeyPath: "yearMonthDay",
                                                                   cacheName: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextObjectsDidChange(_:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
            self.filter(by: selectedCategory)
            self.allEntries { expensesGroups in
                self.groupedExpenses = expensesGroups
            }
        }
    }
    
    public func expensesGroups(completion: @escaping ([ExpensesGroup]) -> Void) {
        allEntries { expensesGroups in
            completion(expensesGroups)
        }
    }
    
    private func allEntries(completion: @escaping ([ExpensesGroup]) -> Void) {
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
                            for case let coreDataEntry as Entry in objects
                            {
                                var tagName: String = ""
                                var iconImageName: String = ""
                                var tagColor: UIColor = .black
                                if let tag = coreDataEntry.tag {
                                    tagName = tag.name
                                    iconImageName = tag.iconImageName
                                    tagColor = tag.color
                                }
                                let category = ExpenseCategory(name: tagName, iconName: iconImageName, color: tagColor)
                                var dateComponents = DateComponents()
                                if let d = coreDataEntry.date {
                                    dateComponents = DateComponents(year: d.component(.year),
                                                                    month: d.component(.month),
                                                                    day: d.component(.day),
                                                                    hour: d.component(.hour),
                                                                    minute: d.component(.minute),
                                                                    second: d.component(.second))
                                }
                                let entry = Expense(dateComponents: dateComponents,
                                                    date: coreDataEntry.date,
                                                    value: coreDataEntry.value,
                                                    valueInBaseCurrency: coreDataEntry.valueInBaseCurrency,
                                                    description: coreDataEntry.desc,
                                                    category: category,
                                                    currencyCode: coreDataEntry.currencyCode,
                                                    exchangeRateToBaseCurrency: coreDataEntry.exchangeRateToBaseCurrency,
                                                    isExchangeRateUpToDate: coreDataEntry.isExchangeRateUpToDate)
                                entry.identifier = coreDataEntry.objectID.copy() as! NSCopying
                                entriesForKey.append(entry)
                            }
                        }
                        
                        let section = ExpensesGroup(groupKey: self.dateComponents(fromSectionKey: sectionInfo.name), entries: entriesForKey)
                        results.append(section)
                    }
        
                    results.sort { g1, g2 in
                        return g1.groupKey < g2.groupKey
                    }
                    completion(results)
            }
        }
    }
    
    private func dateComponents(fromSectionKey key: String) -> DateComponents {
        let components = key.components(separatedBy: "/")
        var year: Int? = nil
        var month: Int? = nil
        var day: Int? = nil

        if let d = components.first,
            let n = Int(d) {
            year = n
        }
        
        if components.count >= 3 {
            month = Int(components[1])
            day = Int(components[2])
        }
        
        return DateComponents(year: year, month: month, day: day)
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        allEntries { expensesGroups in
            self.groupedExpenses = expensesGroups
        }
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allEntries { expensesGroups in
            self.groupedExpenses = expensesGroups
        }
    }

    private func fetchRequestForIndividualEntriesSummary() -> NSFetchRequest<NSFetchRequestResult> {
        let baseRequest = self.baseRequest(context: coreDataContext)
            
        let sorDescriptor = NSSortDescriptor(key: "yearMonthDay", ascending: true)
        baseRequest.sortDescriptors = [sorDescriptor]
        return baseRequest
    }
}
