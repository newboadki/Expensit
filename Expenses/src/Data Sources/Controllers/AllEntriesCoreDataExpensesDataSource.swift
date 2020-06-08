//
//  AllEntriesCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class AllEntriesCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, NSFetchedResultsControllerDelegate {
    
    @Published var groupedExpenses = [ExpensesGroup]()
    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
        
    private(set) var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private(set) var coreDataController: BSCoreDataController
    
    init(coreDataController: BSCoreDataController) {
        self.coreDataController = coreDataController
        self.fetchedResultsController = self.coreDataController.fetchedResultsControllerForAllEntries()
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        self.groupedExpenses = allEntries()
    }
    
    private func allEntries() -> [ExpensesGroup] {
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
                for case let coreDataEntry as Entry in objects
                {
                    var tagName: String = ""
                    var iconImageName: String = ""
                    var tagColor: UIColor = .black
                    if let tag = coreDataEntry.tag {
                        tagName = tag.name
                        iconImageName = tag.iconImageName
                        tagColor = coreDataEntry.tag.color
                    }
                    let category = ExpenseCategory(name: tagName, iconName: iconImageName, color: tagColor)
                    let entry = Expense(date: coreDataEntry.date, value: coreDataEntry.value, description: coreDataEntry.desc, category: category)
                    entry.identifier = coreDataEntry.objectID.copy() as! NSCopying
                    entriesForKey.append(entry)
                }
            }
            let section = ExpensesGroup(key: sectionInfo.name, entries: entriesForKey)
            results.append(section)
        }
        
        return results
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        self.groupedExpenses = allEntries()
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = allEntries()
    }

}
