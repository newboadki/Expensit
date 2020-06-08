//
//  DailyCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class DailyCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, NSFetchedResultsControllerDelegate {
    
    @Published var groupedExpenses = [ExpensesGroup]()
    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
        
    private(set) var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private(set) var coreDataController: BSCoreDataController
    
    init(coreDataController: BSCoreDataController) {
        self.coreDataController = coreDataController
        self.fetchedResultsController = self.coreDataController.fetchedResultsControllerForEntriesGroupedByDay()
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        self.groupedExpenses = entriesGroupedByDay()
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
                    let entry = Expense(date: date, value: dailySum, description: nil, category: nil)
                    entriesForKey.append(entry)
                }
            }
            
            let section = ExpensesGroup(key: sectionInfo.name, entries: entriesForKey)
            results.append(section)
        }
        
        return results

    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        self.groupedExpenses = entriesGroupedByDay()
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = entriesGroupedByDay()
    }

}
