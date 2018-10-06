//
//  BSShowAllEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

struct DisplayModelToCoreDataModelMap {
    var diplayEntry: BSDisplayExpensesSummaryEntry
    var entity: Entry
}

struct AuxiliarlyDisplaySection {
    var title: String
    var date: Date
    var entries: [DisplayModelToCoreDataModelMap]
}

class BSShowAllEntriesPresenter : BSAbstractShowEntriesPresenter {
    
    // This contains
    fileprivate var auxiliarySections = [AuxiliarlyDisplaySection]()
    
    
    // MARK: BSDailyExpensesSummaryPresenterEventsProtocol
    
    /// Transforms the CoreData query results into view-models adapted for a All-entries summary
    ///
    /// - Parameter data: CoreData query results
    /// - Returns: Array of view-models
    override func displayDataFromEntriesForSummary(_ sections : [BSEntryEntityGroup]) -> [BSDisplayExpensesSummarySection]
    {
        var displaySections = [BSDisplayExpensesSummarySection]()
        
        for section in sections
        {
            print(section.groupKey)
            var displayEntries = [BSDisplayExpensesSummaryEntry]()
            let (day, month, year) = self.dateComponents(from: section.groupKey)
            let date = DateTimeHelper.date(withFormat: nil, stringDate: "\(day)/\(month)/\(year)")

            for i in 0 ..< section.entries.count
            {
                let entryEntity : BSExpenseEntry = section.entries[i]
                let sign : BSNumberSignType = self.sign(for: entryEntity.value)
                let displayEntry = BSDisplayExpensesSummaryEntry(title: entryEntity.entryDescription , value: BSCurrencyHelper.amountFormatter().string(from: entryEntity.value), signOfAmount: sign, date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: date), tag: entryEntity.category?.name)
                displayEntry.identifier = entryEntity.identifier
                displayEntries.append(displayEntry)
            }
            
            let displaySection = BSDisplayExpensesSummarySection(title: section.groupKey, entries: displayEntries)
            displaySections.append(displaySection)
        }

        return displaySections
    }
    
    
    public func entry(for indexPath: NSIndexPath) -> Entry {
        return self.auxiliarySections[indexPath.section].entries[indexPath.row].entity
    }
    
    
    
    // MARK: - Helpers
    
    fileprivate func sign(for value: NSNumber) -> BSNumberSignType {
        
        switch value.compare(0)
        {
            case .orderedAscending:
                return .negative
            
            case .orderedDescending:
                return .positive
            
            case .orderedSame:
                return .zero
        }
    }
    
    
    fileprivate func dateComponents(from dateString: String) -> (String, String, String) {
        let components = dateString.components(separatedBy: "/")
        return (year: components[2], month: components[1], day: components[0])
    }
    
}
