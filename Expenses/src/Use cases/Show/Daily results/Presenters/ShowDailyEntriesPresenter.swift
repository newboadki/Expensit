//
//  ShowDailyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine
import DateAndTime

class ShowDailyEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySectionViewModel]> {
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            let sortedGRoups = groups.sorted { (lg, rg) in
                lg.groupKey > rg.groupKey
            }
                        
            var displaySections = [ExpensesSummarySectionViewModel]()
            
            for section in sortedGRoups
            {
                var entries = [ExpensesSummaryEntryViewModel]()
                let monthNumber = section.groupKey.month
                let numberOfDayInMonths = DateConversion.numberOfDays(inMonthNamed: "\(monthNumber!)")
                for i in 0 ..< numberOfDayInMonths {                    
                    let dayData = ExpensesSummaryEntryViewModel(id:DateComponents(year: section.groupKey.year, month: section.groupKey.month, day: i),
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
                    let dateString = DateConversion.string(from: entryEntity.date!)
                    let entryData = ExpensesSummaryEntryViewModel(id:entryEntity.dateComponents,
                                                                  title: dayString as String,
                                                                  value: dailySumString as String,
                                                                  signOfAmount: sign,
                                                                  date: dateString,
                                                                  tag: nil)
                    entries[day.intValue - 1] = entryData
                }
                
                let calendar = Calendar.current
                let dateComponents = DateComponents(calendar: calendar,
                                                    year: section.groupKey.year,
                                                    month: section.groupKey.month,
                                                    day: section.groupKey.day)
                let sectionDate = calendar.date(from: dateComponents)!
                let sectionDateString = DateConversion.string(withFormat: DateFormats.monthYear, from: sectionDate)
                let sectionData = ExpensesSummarySectionViewModel(id:section.groupKey, title: sectionDateString, entries: entries)
                displaySections.append(sectionData)
            }
            
            return displaySections
        }
        
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 7
    }    
}
