//
//  ShowMonthlyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 26/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import DateAndTime

public class ShowMonthlyEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override public func displayDataFromEntriesForSummary() -> AnyPublisher<[ExpensesSummarySectionViewModel], Never> {
                
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            let sortedGroups = groups
            var displaySections = [ExpensesSummarySectionViewModel]()

            // Each section is a year
            for section in sortedGroups
            {
                var entries = [ExpensesSummaryEntryViewModel]()
                // We always show all months even if they have no expenses
                for i in 0 ..< 12 {
                    let monthData = ExpensesSummaryEntryViewModel(id: DateComponents(year: section.groupKey.year, month: Int(i+1), day: nil),
                                                                  title: DateConversion.monthName(for: i+1).uppercased(),
                                                                  value: "",
                                                                  signOfAmount: .zero,
                                                                  date: nil,
                                                                  tag: nil,
                                                                  currencyCode: "")
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
                    let month = entryEntity.month!
                    let monthString = DateConversion.monthName(for: month).uppercased()
                    let monthlySumString = DefaultExpenseCurrencyFormatter.amountFormatter().string(from: value)!
                    let entryData = ExpensesSummaryEntryViewModel(id: entryEntity.dateComponents,
                                                                  title: monthString as String,
                                                                  value: monthlySumString as String,
                                                                  signOfAmount: sign,
                                                                  date: nil,
                                                                  tag: nil,
                                                                  currencyCode: "")
                    entries[month - 1] = entryData
                }

                let sectionData = ExpensesSummarySectionViewModel(id:section.groupKey, title: "\(section.groupKey.year ?? 0)", entries: entries)
                displaySections.append(sectionData)
            }

            return displaySections
        }.eraseToAnyPublisher()
    }
    
    public override func preferredNumberOfColumns() -> Int {
        return 4
    }    
}
