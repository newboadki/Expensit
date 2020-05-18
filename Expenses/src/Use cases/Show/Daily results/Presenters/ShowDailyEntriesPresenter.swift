//
//  ShowDailyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class ShowDailyEntriesPresenter: AbstractEntriesSummaryPresenter {
    
    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySection]> {
    
        
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
                        
            var displaySections = [ExpensesSummarySection]()
            
            for (sectionIndex, section) in groups.enumerated()
            {
                var entries = [DisplayExpensesSummaryEntry]()
                let monthNumber = section.groupKey.components(separatedBy: "/")[0]
                let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: monthNumber).length
                for i in 0 ..< numberOfDayInMonths {
                                        
                    let dayData = DisplayExpensesSummaryEntry(id:i+1, title: "\(i+1)" , value: "", signOfAmount: .zero, date: nil, tag: nil)
                    entries.append(dayData)
                }
                
                for (entryIndex, entryEntity) in section.entries.enumerated()
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
                    let entryData = DisplayExpensesSummaryEntry(id:entryIndex, title: dayString as String , value: dailySumString as String, signOfAmount: sign, date: dateString, tag: nil)
                    entries[day.intValue - 1] = entryData
                }
                
                let sectionData = ExpensesSummarySection(id:sectionIndex, title: section.groupKey, entries: entries)
                displaySections.append(sectionData)
            }
            
            return displaySections
        }
        
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 7
    }

}
