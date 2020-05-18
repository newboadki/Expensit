//
//  ShowMonthlyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 26/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class ShowMonthlyEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySection]> {
        
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            let sortedGroups = groups.sorted { (g1, g2) in
                return (g1.groupKey > g2.groupKey)
            }
            var displaySections = [ExpensesSummarySection]()

            for (sectionIndex, section) in sortedGroups.enumerated() // Each section is a year
            {
                var entries = [DisplayExpensesSummaryEntry]()
                for i in 0 ..< 12 { // We always show all months even if they have no expenses
                    
                    let monthData = DisplayExpensesSummaryEntry(id: i, title: DateTimeHelper.monthName(forMonthNumber: NSNumber(value: i+1)).uppercased(), value: "", signOfAmount: .zero, date: nil, tag: nil)
                    entries.append(monthData)
                }
                
                for (entryIndex, entryEntity) in section.entries.enumerated() // No populate the month that do have expenses
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

                    let entryData = DisplayExpensesSummaryEntry(id: entryIndex, title: monthString as String , value: monthlySumString as String, signOfAmount: sign, date: nil, tag: nil)
                    entries[month.intValue - 1] = entryData
                }

                let sectionData = ExpensesSummarySection(id:sectionIndex, title: section.groupKey, entries: entries)
                displaySections.append(sectionData)
            }

            return displaySections
        }
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 4
    }
}
