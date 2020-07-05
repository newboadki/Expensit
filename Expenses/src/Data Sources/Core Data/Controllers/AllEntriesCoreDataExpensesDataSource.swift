//
//  AllEntriesCoreDataExpensesDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class AllEntriesCoreDataExpensesDataSource: NSObject, EntriesSummaryDataSource, NSFetchedResultsControllerDelegate {
    
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
        self.fetchedResultsController = self.coreDataController.fetchedResultsControllerForAllEntries()
        self.selectedCategoryDataSource = selectedCategoryDataSource
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)        
        
        self.cancellableSelectedCategoryUpdates = self.selectedCategoryDataSource.selectedCategoryPublisher.sink { selectedCategory in
            self.filter(by: selectedCategory)
            self.groupedExpenses = self.allEntries()
        }
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
                    
                    let entry = Expense(dateComponents: DateComponents(year: coreDataEntry.date.component(.year), month: coreDataEntry.date.component(.month), day: coreDataEntry.date.component(.day), hour:coreDataEntry.date.component(.hour), minute: coreDataEntry.date.component(.minute), second:coreDataEntry.date.component(.second)), date: coreDataEntry.date, value: coreDataEntry.value, description: coreDataEntry.desc, category: category)
                    entry.identifier = coreDataEntry.objectID.copy() as! NSCopying
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
        self.groupedExpenses = allEntries()
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.groupedExpenses = allEntries()
    }

}
