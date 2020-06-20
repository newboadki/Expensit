//
//  ShowMonthlyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 26/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class ShowMonthlyEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySectionViewModel]> {
                
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            let sortedGroups = groups.sorted { (g1, g2) in
                return (g1.groupKey > g2.groupKey)
            }
            var displaySections = [ExpensesSummarySectionViewModel]()

            // Each section is a year
            for section in sortedGroups
            {
                var entries = [ExpensesSummaryEntryViewModel]()
                // We always show all months even if they have no expenses
                for i in 0 ..< 12 {
                    
                    let identifier = "\(section.groupKey)/\(i+1)"
                    let monthData = ExpensesSummaryEntryViewModel(id: identifier, title: DateTimeHelper.monthName(forMonthNumber: NSNumber(value: i+1)).uppercased(), value: "", signOfAmount: .zero, date: nil, tag: nil)
                    entries.append(monthData)
                }
                
                // Now populate the month that do have expenses
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
                    let identifier = "\(section.groupKey)/\(month)"
                    let entryData = ExpensesSummaryEntryViewModel(id: identifier, title: monthString as String , value: monthlySumString as String, signOfAmount: sign, date: nil, tag: nil)
                    entries[month.intValue - 1] = entryData
                }

                let sectionData = ExpensesSummarySectionViewModel(id:section.groupKey, title: section.groupKey, entries: entries)
                displaySections.append(sectionData)
            }

            return displaySections
        }
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 4
    }
    
    override func dateComponents(fromIdentifier identifier: String) -> (year: Int, month: Int?, day: Int?) {
        let components = identifier.components(separatedBy: "/")
        var year: Int = 0
        var month: Int? = nil
        if let y = components.first,
            let n = Int(y) {
            year = n
        }
        
        if components.count >= 2 {
            month = Int(components[1])
        }
        
        return (year, month, nil)
    }

    
    
}
