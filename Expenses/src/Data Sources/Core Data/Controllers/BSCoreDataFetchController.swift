//
//  BSCoreDataFetchController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 08/01/2018.
//  Copyright © 2018 Borja Arias Drake. All rights reserved.
//

import UIKit
import CoreExpenses

@objc class BSCoreDataFetchController: NSObject {

    @objc enum FetchControllerType: Int {
        case yearly
        case monthly
        case daily
        case all
    }
    
    private var fetchControllers: [FetchControllerType : NSFetchedResultsController<NSFetchRequestResult>]
    internal var coreDataController: BSCoreDataController
    
    
    
    // MARK: - Private
    
    @objc init(coreDataController: BSCoreDataController) {
        self.coreDataController = coreDataController
        self.fetchControllers = [FetchControllerType : NSFetchedResultsController<NSFetchRequestResult>]()
        self.fetchControllers[.yearly] = self.coreDataController.fetchedResultsControllerForEntriesGroupedByYear()
        self.fetchControllers[.monthly] = self.coreDataController.fetchedResultsControllerForEntriesGroupedByMonth()
        self.fetchControllers[.daily] = self.coreDataController.fetchedResultsControllerForEntriesGroupedByDay()
        self.fetchControllers[.all] = self.coreDataController.fetchedResultsControllerForAllEntries()
        super.init()
    }

    
    
    // MARK: - Filtering
    
    @objc func filter(summaryType: FetchControllerType, by category: ExpenseCategory?) {
        let fetchController = self.fetchControllers[summaryType]
        if let category = category {
            let tag = self.coreDataController.tag(forName: category.name)
            self.coreDataController.modifyfetchRequest((fetchController!.fetchRequest), toFilterByCategory: tag)
        } else {
            self.coreDataController.modifyfetchRequest((fetchController!.fetchRequest), toFilterByCategory: nil)
        }
    }
    
    @objc func image(for category: ExpenseCategory?) -> UIImage? {
        return self.coreDataController.image(forCategoryName: category?.name)
    }
    
    // MARK: - Editing
    
    public func saveChanges()
    {
        self.coreDataController.saveChanges()
    }
    
    public func save(existingEntry expenseEntryEntity: Expense) -> (Bool, NSError?)
    {
        var entryToSave: Entry?
        
        if let identifier = expenseEntryEntity.identifier as? NSManagedObjectID {
            let coreDataEntry = self.coreDataController.coreDataHelper.managedObjectContext.object(with: identifier) as! Entry
            entryToSave = coreDataEntry
        } else {
            entryToSave = self.coreDataController.newEntry()
        }
        
        entryToSave!.date = expenseEntryEntity.date
        entryToSave!.desc = expenseEntryEntity.entryDescription
        entryToSave!.value = expenseEntryEntity.value
        entryToSave!.tag = self.coreDataController.tag(forName: (expenseEntryEntity.category?.name)!)

        do {
            try self.coreDataController.save(entryToSave!)
            return (true, nil)
        } catch {
            return (false, error as NSError)
        }
    }

    public func delete(entry: Expense)
    {
        if let identifier = entry.identifier as? NSManagedObjectID {
            let coreDataEntry = self.coreDataController.coreDataHelper.managedObjectContext.object(with: identifier) as! Entry
            self.coreDataController.deleteModel(coreDataEntry)
        }
    }
    
    
    
    // MARK: - Private
    
    private func performRequest(on fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) -> [NSFetchedResultsSectionInfo]? {
        do
        {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.sections
        }
        catch
        {
            return nil
        }
    }

}


// MARK: - Yearly line graph

extension BSCoreDataFetchController {
    
    func abscissaValuesForYearlyLineGraph() -> [NSDictionary] {
        let request = self.coreDataController.requestToGetYears()
        
        do {
            let output = try self.coreDataController.results(for: request)
            return output as! [NSDictionary]
        }
        catch {
            return []
        }
    }
    
    func graphSurplusResultsForYearlyLineGraph(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphYearlySurplusFetchRequest()
        do {
            let output = try self.coreDataController.results(for: request)
            return output as [AnyObject]
        }
        catch {
            return []
        }
    }
    
    func graphExpensesResultsForYearlyLineGraph(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphYearlyExpensesFetchRequest()
        do {
            let output = try self.coreDataController.results(for: request)
            return output as [AnyObject]
        }
        catch {
            return []
        }
    }
}

// MARK: - Monthly line graph

extension BSCoreDataFetchController {
    func abscissaValuesForMonthlyLineGraph() -> [NSDictionary] {
        return []
    }
    
    func graphSurplusResultsForMonthlyLineGraph(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphMonthlySurplusFetchRequest(forSectionName: section)
        
        do {
            let output = try self.coreDataController.results(for: request)
            return output as [AnyObject]
        }
        catch {
            return []
        }
    }
    
    func graphExpensesResultsForMonthlyLineGraph(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphMonthlyExpensesFetchRequest(forSectionName: section)
        do {
            let output = try self.coreDataController.results(for: request)
            return output as [AnyObject]
        }
        catch {
            return []
        }
    }
}

// MARK: - Daily line graph

extension BSCoreDataFetchController {
    func abscissaValuesForDailyLineGraph() -> [NSDictionary] {
        return []
    }
    
    func graphSurplusResultsForDailyLineGraph(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphDailySurplusFetchRequest(forSectionName: section)
        
        do {
            let output = try self.coreDataController.results(for: request)
            return output as [AnyObject]
        }
        catch {
            return []
        }
    }
    
    func graphExpensesResultsForDailyLineGraph(for section: String) -> [AnyObject] {
        let request = self.coreDataController.graphDailyExpensesFetchRequest(forSectionName: section)
        do {
            let output = try self.coreDataController.results(for: request)
            return output as [AnyObject]
        }
        catch {
            return []
        }
    }
}
