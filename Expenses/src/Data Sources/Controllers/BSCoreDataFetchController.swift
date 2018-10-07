//
//  BSCoreDataFetchController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 08/01/2018.
//  Copyright © 2018 Borja Arias Drake. All rights reserved.
//

import UIKit

class BSCoreDataFetchController: NSObject {

    public enum FetchControllerType {
        case yearly
        case monthly
        case daily
        case all
    }
    
    private var fetchControllers: [FetchControllerType : NSFetchedResultsController<NSFetchRequestResult>]
    internal var coreDataController: BSCoreDataController
    
    
    
    // MARK: - Private
    
    init(coreDataController: BSCoreDataController) {
        self.coreDataController = coreDataController
        self.fetchControllers = [FetchControllerType : NSFetchedResultsController<NSFetchRequestResult>]()
        self.fetchControllers[.yearly] = self.coreDataController.fetchedResultsControllerForEntriesGroupedByYear()
        self.fetchControllers[.monthly] = self.coreDataController.fetchedResultsControllerForEntriesGroupedByMonth()
        self.fetchControllers[.daily] = self.coreDataController.fetchedResultsControllerForEntriesGroupedByDay()
        self.fetchControllers[.all] = self.coreDataController.fetchedResultsControllerForAllEntries()
        super.init()
    }

    
    
    // MARK: - Filtering
    
    public func filter(summaryType: FetchControllerType, by category: BSExpenseCategory?) {
        let fetchController = self.fetchControllers[summaryType]
        if let category = category {
            let tag = self.coreDataController.tag(forName: category.name)
            self.coreDataController.modifyfetchRequest((fetchController?.fetchRequest)!, toFilterByCategory: tag)
        } else {
            self.coreDataController.modifyfetchRequest((fetchController?.fetchRequest)!, toFilterByCategory: nil)
        }
    }
    
    public func image(for category: BSExpenseCategory?) -> UIImage? {
        return self.coreDataController.image(forCategoryName: category?.name)
    }
    
    
    
    // MARK: - Summary results
    
    public func entriesGroupedByYear() -> [BSEntryEntityGroup]
    {
        let fetchController = self.fetchControllers[.yearly]
        let sections = self.performRequest(on: fetchController!)
        var results = [BSEntryEntityGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections!
        {
            var entriesForKey = [BSExpenseEntry]()
            if let objects = sectionInfo.objects
            {
                for case let data as NSDictionary in objects
                {
                    let yearlySum = data["yearlySum"] as! NSDecimalNumber
                    let date = data["date"] as! Date
                    let entry = BSExpenseEntry(date: date, value: yearlySum, description: nil, category: nil)
                    entriesForKey.append(entry)
                }
            }
            let section = BSEntryEntityGroup(key: sectionInfo.name, entries: entriesForKey)
            results.append(section)
        }
        
        return results
    }

    public func entriesGroupedByMonth() -> [BSEntryEntityGroup]
    {
        let fetchController = self.fetchControllers[.monthly]
        let sections = self.performRequest(on: fetchController!)
        var results = [BSEntryEntityGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections!
        {
            var entriesForKey = [BSExpenseEntry]()
            if let objects = sectionInfo.objects {
                for case let data as NSDictionary in objects {
                    let monthlySum = data["monthlySum"] as! NSDecimalNumber
                    let date = data["date"] as! Date
                    let entry = BSExpenseEntry(date: date, value: monthlySum, description: nil, category: nil)
                    entriesForKey.append(entry)
                }
            }
            let section = BSEntryEntityGroup(key: sectionInfo.name, entries: entriesForKey)
            results.append(section)
        }
        
        return results
    }

    public func entriesGroupedByDay() -> [BSEntryEntityGroup] {
        
        let fetchController = self.fetchControllers[.daily]
        let sections = self.performRequest(on: fetchController!)
        var results = [BSEntryEntityGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections! {
            var entriesForKey = [BSExpenseEntry]()
            if let objects = sectionInfo.objects {
                for case let data as NSDictionary in objects {
                    let dailySum = data["dailySum"] as! NSDecimalNumber
                    let date = data["date"] as! Date
                    let entry = BSExpenseEntry(date: date, value: dailySum, description: nil, category: nil)
                    entriesForKey.append(entry)
                }
            }
            
            let section = BSEntryEntityGroup(key: sectionInfo.name, entries: entriesForKey)
            results.append(section)
        }
        
        return results

    }

    public func allEntries() -> [BSEntryEntityGroup]
    {
        let fetchController = self.fetchControllers[.all]
        let sections = self.performRequest(on: fetchController!)
        var results = [BSEntryEntityGroup]()
        
        guard sections != nil else {
            return results
        }
        
        for sectionInfo in sections!
        {
            var entriesForKey = [BSExpenseEntry]()
            if let objects = sectionInfo.objects
            {
                for case let coreDataEntry as Entry in objects
                {
                    let category = BSExpenseCategory(name: coreDataEntry.tag.name, iconName: coreDataEntry.tag.iconImageName ?? "", color: coreDataEntry.tag.color ?? UIColor.black)
                    let entry = BSExpenseEntry(date: coreDataEntry.date, value: coreDataEntry.value, description: coreDataEntry.desc, category: category)
                    entry.identifier = coreDataEntry.objectID.copy() as! NSCopying
                    entriesForKey.append(entry)
                }
            }
            let section = BSEntryEntityGroup(key: sectionInfo.name, entries: entriesForKey)
            results.append(section)
        }
        
        return results
    }
    
    // MARK: - Editing
    
    public func save(existingEntry expenseEntryEntity: BSExpenseEntry) -> (Bool, NSError?)
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

    public func delete(entry: BSExpenseEntry)
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


// MARK: - Categories
extension BSCoreDataFetchController {
    
    func categories(forMonth month: NSNumber?, inYear year: NSNumber) -> [BSExpenseCategory]? {
        let tags = self.coreDataController.categories(forMonth: month, inYear: year)
        let categories = tags?.map({ (tag) -> BSExpenseCategory in
            return BSExpenseCategory(name: tag.name, iconName: tag.iconImageName, color: tag.color)
        })
        
        return categories
    }
    
    
    func sortedCategoriesByPercentage(fromCategories categories: [BSExpenseCategory], sections: [BSPieChartSectionInfo]) -> [BSExpenseCategory]
    {
        var results = [BSExpenseCategory]()

        for section in sections.reversed() {
            let filteredArray = categories.filter() { $0.name == section.name }
            if let category = filteredArray.first {
                results.append(category)
            }
        }
        return results
    }
    
    func expensesByCategory(forMonth month: NSNumber?, inYear year: NSNumber) -> [BSPieChartSectionInfo] {
        return self.coreDataController.expensesByCategory(forMonth: month, inYear: year)
    }
}

