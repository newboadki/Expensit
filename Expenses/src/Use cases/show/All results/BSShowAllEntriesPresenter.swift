//
//  BSShowAllEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

struct DisplayModelToCoreDataModelMap {
    var diplayEntry: BSDisplayEntry
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
    override func displayDataFromEntriesForSummary(_ data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        var sections = [BSDisplaySectionData]()
        auxiliarySections = [AuxiliarlyDisplaySection]()
        
        for coreDatasectionInfo in data
        {
            //var entries = [BSDisplayEntry]()
            var auxEntries = [DisplayModelToCoreDataModelMap]()
            
            for i in 0 ..< coreDatasectionInfo.numberOfObjects {

                let coreDataEntry : Entry = coreDatasectionInfo.objects![i] as! Entry
                let sign : BSNumberSignType = self.sign(for: coreDataEntry.value)
                let entryData = BSDisplayEntry(title: coreDataEntry.desc , value: BSCurrencyHelper.amountFormatter().string(from: coreDataEntry.value), signOfAmount: sign)
                let auxEntry = DisplayModelToCoreDataModelMap(diplayEntry: entryData, entity: coreDataEntry)
                auxEntries.append(auxEntry)
            }
            
            let (year, month, day) = self.dateComponents(from: coreDatasectionInfo.name)
            let date = DateTimeHelper.date(withFormat: nil, stringDate: "\(day)/\(month)/\(year)")
            
            // TODO: Need to encapsulate. This string needs to match the one created at BSShowDailyEntriesPresenter.
            let reversed = "\(day) \(DateTimeHelper.monthName(forMonthNumber: NSDecimalNumber(string: month))!) \(year)"
            let auxSection = AuxiliarlyDisplaySection(title: reversed, date: date!, entries: auxEntries)
            
            auxiliarySections.append(auxSection)
        }
        
        auxiliarySections = auxiliarySections.sorted { $0.date < $1.date }
        sections = auxiliarySections.map {
            let displayEntries = $0.entries.map { $0.diplayEntry }
            return  BSDisplaySectionData(title: $0.title, entries: displayEntries)
        }
        return sections
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
        return (year: components[0], month: components[1], day: components[2])
    }
    
}
