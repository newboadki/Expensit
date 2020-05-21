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
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySection]> {
        print("All Entries Presenter called.")
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            var displaySections = [ExpensesSummarySection]()
            let sortedGroups = groups.sorted { (g1, g2) in
                return (g1.groupKey > g2.groupKey)
            }
            
            for (sectionIndex, section) in sortedGroups.enumerated()
            {
                var displayEntries = [DisplayExpensesSummaryEntry]()
                let (day, month, year) = self.dateComponents(from: section.groupKey)
                let date = DateTimeHelper.date(withFormat: nil, stringDate: "\(day)/\(month)/\(year)")

                for i in 0 ..< section.entries.count
                {
                    let entryEntity : Expense = section.entries[i]
                    let sign : BSNumberSignType = self.sign(for: entryEntity.value)
                    let displayEntry = DisplayExpensesSummaryEntry(id:i, title: entryEntity.entryDescription , value: BSCurrencyHelper.amountFormatter().string(from: entryEntity.value), signOfAmount: sign, date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: date), tag: entryEntity.category?.name)
                    //displayEntry.identifier = entryEntity.identifier
                    displayEntries.append(displayEntry)
                }
                
                let displaySection = ExpensesSummarySection(id:sectionIndex, title: section.groupKey, entries: displayEntries)
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