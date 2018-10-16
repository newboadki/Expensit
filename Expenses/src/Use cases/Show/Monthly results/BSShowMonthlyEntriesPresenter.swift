//
//  BSShowMonthlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowMonthlyEntriesPresenter : BSAbstractShowEntriesPresenter
{    
    // MARK: From BSAbstractShowEntriesPresenter
    
    /// Transforms the CoreData query results into view-models adapted for a Monthly summary
    ///
    /// - Parameter data: CoreData query results
    /// - Returns: Array of view-models
    override func displayDataFromEntriesForSummary(_ sections : [BSEntryEntityGroup]) -> [BSDisplayExpensesSummarySection]
    {
        var displaySections = [BSDisplayExpensesSummarySection]()

        for section in sections
        {
            var entries = [BSDisplayExpensesSummaryEntry]()
            for i in 0 ..< 12 {
                let monthData = BSDisplayExpensesSummaryEntry(title: DateTimeHelper.monthName(forMonthNumber: NSNumber(value: i+1)).uppercased(), value: "", signOfAmount: .zero, date: nil, tag: nil)
                entries.append(monthData)
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
                let month = NSNumber(value: entryEntity.month!)
                let monthString = DateTimeHelper.monthName(forMonthNumber: month).uppercased()
                let monthlySumString = BSCurrencyHelper.amountFormatter().string(from: value)!

                let entryData = BSDisplayExpensesSummaryEntry(title: monthString as String , value: monthlySumString as String, signOfAmount: sign, date: nil, tag: nil)
                entries[month.intValue - 1] = entryData
            }

            let sectionData = BSDisplayExpensesSummarySection(title: section.groupKey, entries: entries)
            displaySections.append(sectionData)
        }

        return displaySections
    }

}
