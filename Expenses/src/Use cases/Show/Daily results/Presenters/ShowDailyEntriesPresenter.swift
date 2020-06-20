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
                let monthNumber = section.groupKey.components(separatedBy: "/")[0]
                let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: monthNumber).length
                for i in 0 ..< numberOfDayInMonths {
                    let identifier = "\(i+1)/\(section.groupKey)"
                    let dayData = ExpensesSummaryEntryViewModel(id:identifier, title: "\(i+1)" , value: "", signOfAmount: .zero, date: nil, tag: nil)
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
                    let identifier = "\(dayString)/\(section.groupKey)"
                    let entryData = ExpensesSummaryEntryViewModel(id:identifier, title: dayString as String , value: dailySumString as String, signOfAmount: sign, date: dateString, tag: nil)
                    entries[day.intValue - 1] = entryData
                }
                
                let sectionData = ExpensesSummarySectionViewModel(id:section.groupKey, title: section.groupKey, entries: entries)
                displaySections.append(sectionData)
            }
            
            return displaySections
        }
        
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 7
    }
    
    override func dateComponents(fromIdentifier identifier: String) -> (year: Int, month: Int?, day: Int?) {
        let components = identifier.components(separatedBy: "/")
        var year: Int = 0
        var month: Int? = nil
        if let m = components.first,
            let n = Int(m) {
            month = n
        }
        
        if components.count >= 2 {
            year = Int(components[1]) ?? 0
        }
        
        return (year, month, nil)
    }

}
