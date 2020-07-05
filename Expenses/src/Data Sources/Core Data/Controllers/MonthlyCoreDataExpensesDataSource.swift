//
//  MonthlyCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 26/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class MonthlyCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, NSFetchedResultsControllerDelegate {
        
    @Published var groupedExpenses = [ExpensesGroup]()
    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
        
    private(set) var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private(set) var coreDataController: BSCoreDataController
    private var selectedCategoryDataSource: CategoryDataSource
    private var cancellableSelectedCategoryUpdates: AnyCancellable?

    init(coreDataController: BSCoreDataController,
         selectedCategoryDataSource: CategoryDataSource) {
        self.coreDataController = coreDataController
        self.fetchedResultsController =
        self.coreDataController.fetchedResultsControllerForEntriesGroupedByMonth()
        self.selectedCategoryDataSource = selectedCategoryDataSource
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        self.groupedExpenses = entriesGroupedByMonth()
        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
            self.filter(by: selectedCategory)
            self.groupedExpenses = self.entriesGroupedByMonth()
        }
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
                                        description: nil,
                                        category: nil)
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
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = entriesGroupedByMonth()
    }

}