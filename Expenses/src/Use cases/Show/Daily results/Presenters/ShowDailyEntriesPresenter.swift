//
//  ShowDailyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class ShowDailyEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySectionViewModel]> {
    
        print("Daily Presenter called.")
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
                        
            var displaySections = [ExpensesSummarySectionViewModel]()
            
            for section in groups
            {
                var entries = [ExpensesSummaryEntryViewModel]()
                let monthNumber = section.groupKey.month
                let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: "\(monthNumber!)").length
                for i in 0 ..< numberOfDayInMonths {                    
                    let dayData = ExpensesSummaryEntryViewModel(id:DateIdentifier(year: section.groupKey.year, month: section.groupKey.month, day: UInt(i)),
                                                                title: "\(i+1)",
                            value: "",
                        signOfAmount: .zero,
                        date: nil,
                        tag: nil)
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
                    let entryData = ExpensesSummaryEntryViewModel(id:entryEntity.dateIdentifier,
                                                                  title: dayString as String,
                                                                  value: dailySumString as String,
                                                                  signOfAmount: sign,
                                                                  date: dateString,
                                                                  tag: nil)
                    entries[day.intValue - 1] = entryData
                }
                
                let sectionData = ExpensesSummarySectionViewModel(id:section.groupKey, title: "\(section.groupKey.month ?? 0)/\(section.groupKey.year ?? 0)", entries: entries)
                displaySections.append(sectionData)
            }
            
            return displaySections
        }
        
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 7
    }    
}
