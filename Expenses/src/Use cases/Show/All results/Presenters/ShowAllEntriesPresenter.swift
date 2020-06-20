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
            let groups = expensesGroups as [ExpensesGroup]
            var displaySections = [ExpensesSummarySectionViewModel]()
            let sortedGroups = groups.sorted { (g1, g2) in
                return (g1.groupKey > g2.groupKey)
            }
            
            for (sectionIndex, section) in sortedGroups.enumerated()
            {
                var displayEntries = [ExpensesSummaryEntryViewModel]()
                let (day, month, year) = self.dateComponents(from: section.groupKey)
                let date = DateTimeHelper.date(withFormat: nil, stringDate: "\(day)/\(month)/\(year)")

                let sortedEntries = section.entries.sorted { (e1, e2) in
                    return (e1.date! < e2.date!)
                }
                for i in 0 ..< sortedEntries.count
                {
                    let entryEntity : Expense = sortedEntries[i]
                    let sign : BSNumberSignType = self.sign(for: entryEntity.value)
                    let displayEntry = ExpensesSummaryEntryViewModel(id:"\(i)", title: entryEntity.entryDescription , value: BSCurrencyHelper.amountFormatter().string(from: entryEntity.value), signOfAmount: sign, date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: date), tag: entryEntity.category?.name)
                    //displayEntry.identifier = entryEntity.identifier
                    displayEntries.append(displayEntry)
                }
                
                let displaySection = ExpensesSummarySectionViewModel(id:"\(sectionIndex)", title: section.groupKey, entries: displayEntries)
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
