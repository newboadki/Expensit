//
//  YearlyCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

class YearlyCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, NSFetchedResultsControllerDelegate {

    @Published var groupedExpenses = [ExpensesGroup]()
    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
    
    private(set) var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private(set) var coreDataController: BSCoreDataController
    
    private var selectedCategoryDataSource: SelectedCategoryDataSource
    
    private var cancellableSelectedCategoryUpdates: AnyCancellable?
    
    init(coreDataController: BSCoreDataController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.coreDataController = coreDataController
        self.fetchedResultsController = self.coreDataController.fetchedResultsControllerForEntriesGroupedByYear()
        self.selectedCategoryDataSource = selectedCategoryDataSource
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)

        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.$selectedCategory.sink { selectedCategory in            
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
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = entriesGroupedByYear()
    }
}
