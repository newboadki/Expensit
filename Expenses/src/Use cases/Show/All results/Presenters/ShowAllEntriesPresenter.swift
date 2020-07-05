//
//  ShowAllEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 21/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

import Combine

class ShowAllEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySectionViewModel]> {
        print("All Entries Presenter called.")
        return self.interactor.entriesForSummary().map { expensesGroups in
            var displaySections = [ExpensesSummarySectionViewModel]()
            let groups = expensesGroups as [ExpensesGroup]
            let sortedGroups = groups.sorted { (lg, rg) in
                return lg.groupKey > rg.groupKey
            }
            
            for section in sortedGroups
            {
                var displayEntries = [ExpensesSummaryEntryViewModel]()
                let dateTitle = "\(section.groupKey.day ?? 0)/\(section.groupKey.month ?? 0)/\(section.groupKey.year ?? 0)"
                let date = DateTimeHelper.date(withFormat: nil, stringDate: dateTitle)

                let sortedEntries = section.entries.sorted { (e1, e2) in
                    return (e1.date! < e2.date!)
                }
                for i in 0 ..< sortedEntries.count
                {
                    let entryEntity : Expense = sortedEntries[i]
                    let sign : BSNumberSignType = self.sign(for: entryEntity.value)
                    let displayEntry = ExpensesSummaryEntryViewModel(id: entryEntity.dateComponents,
                                                                     title: entryEntity.entryDescription,
                                                                     value: BSCurrencyHelper.amountFormatter().string(from: entryEntity.value),
                                                                     signOfAmount: sign,
                                                                     date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: date),
                                                                     tag: entryEntity.category?.name,
                                                                     dateTime: entryEntity.date!)                    
                    displayEntries.append(displayEntry)
                }
                
                let calendar = Calendar.current
                let dateComponents = DateComponents(calendar: calendar,
                                                    year: section.groupKey.year,
                                                    month: section.groupKey.month,
                                                    day: section.groupKey.day)
                let sectionDate = calendar.date(from: dateComponents)!
                let sectionDateString = DateTimeHelper.dateString(withFormat: DAY_MONTH_YEAR_DATE_FORMAT, date: sectionDate)
                let displaySection = ExpensesSummarySectionViewModel(id:section.groupKey, title: sectionDateString, entries: displayEntries)
                displaySections.append(displaySection)
            }

            return displaySections
        }
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 1
    }

    private func sign(for value: NSNumber) -> BSNumberSignType {
        
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
    
    
    private func dateComponents(from dateString: String) -> (String, String, String) {
        let components = dateString.components(separatedBy: "/")
        return (year: components[2], month: components[1], day: components[0])
    }

}
