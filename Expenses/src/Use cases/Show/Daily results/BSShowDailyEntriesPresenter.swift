//
//  BSShowDailyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowDailyEntriesPresenter : BSAbstractShowEntriesPresenter, BSDailyExpensesSummaryPresenterEventsProtocol {

    var visibleSection : String = ""
        

    
    // MARK: BSDailyExpensesSummaryPresenterEventsProtocol
    
    /// Transforms the CoreData query results into view-models adapted for a Daily summary
    ///
    /// - Parameter data: CoreData query results
    /// - Returns: Array of view-models
    override func displayDataFromEntriesForSummary(_ sections : [BSEntryEntityGroup]) -> [BSDisplayExpensesSummarySection]
    {
        
        var displaySections = [BSDisplayExpensesSummarySection]()
        
        for section in sections
        {
            var entries = [BSDisplayExpensesSummaryEntry]()
            let monthNumber = section.groupKey.components(separatedBy: "/")[0]
            let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: monthNumber).length
            for i in 0 ..< numberOfDayInMonths {
                
                let dayData = BSDisplayExpensesSummaryEntry(title: "\(i+1)" , value: "", signOfAmount: .zero, date: nil, tag: nil)
                entries.append(dayData)
            }
            
            for entryEntity in section.entries
            {
                let value = entryEntity.value
                let r : ComparisonResult = value.compare(0)
                var sign : BSNumberSignType
                
                switch r
                {
                case ComparisonResult.orderedAscending:
                    sign = .negative
                case ComparisonResult.orderedDescending:
                    sign = .positive
                case ComparisonResult.orderedSame:
                    sign = .zero
                }
                let day = NSNumber(value: entryEntity.day!)
                let dayString = "\(day)"
                let dailySumString = BSCurrencyHelper.amountFormatter().string(from: value)!
                
                let dateString = DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: entryEntity.date)
                let entryData = BSDisplayExpensesSummaryEntry(title: dayString as String , value: dailySumString as String, signOfAmount: sign, date: dateString, tag: nil)
                entries[day.intValue - 1] = entryData
            }
            
            let sectionData = BSDisplayExpensesSummarySection(title: section.groupKey, entries: entries)
            displaySections.append(sectionData)
        }
        
        return displaySections
    }
    
    
    /// User-readble representation of the title of a section.
    ///
    /// - Parameters:
    ///   - indexPath: Index.row represents the day of the month.
    ///   - sectionTitle: String formated date: "<month>/<year>"
    /// - Returns: User-readble representation of the title of a section.
    /// - Important: TODO: Need to encapsulate. This string needs to match the one created at BSShowAllEntriesPresenter.
    func sectionName(forSelected indexPath : IndexPath, sectionTitle: String) -> String {
        let month = sectionTitle.components(separatedBy: "/")[0]
        let year = sectionTitle.components(separatedBy: "/")[1]
        //return "\((indexPath as NSIndexPath).row + 1) \(DateTimeHelper.monthName(forMonthNumber: NSDecimalNumber(string: month))!) \(year)"
//        return "\((indexPath as NSIndexPath).row + 1)/\(month)/\(year)"
        return "\(year)/\(month)/\((indexPath as NSIndexPath).row + 1)"
    }

}
