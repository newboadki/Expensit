//
//  ShowYearlyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class ShowYearlyEntriesPresenter: AbstractEntriesSummaryPresenter {
            
    
    override var title: String {
        get {"Yearly Summary" }
        
        set{ super.title = newValue}
        
    }

    override func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySection]> {
                        
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            var displaySections = [ExpensesSummarySection]()
            
            for (sectionIndex, section) in groups.enumerated()
            {
                
                let entryEntities = section.entries
                var displayEntries = [DisplayExpensesSummaryEntry]()
                for (entryIndex, entryEntity) in entryEntities.enumerated()
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
                    let year = entryEntity.year
                    let yearString =  (year != nil) ? "\(year!)" : "" // NSString(format:"\(String(describing: year))" as NSString)
                    let yearlySumString = BSCurrencyHelper.amountFormatter().string(from: value)!

                    let displayEntry = DisplayExpensesSummaryEntry(id: entryIndex, title: yearString as String , value: yearlySumString as String, signOfAmount: sign, date:nil, tag: nil)
                    displayEntries.append(displayEntry)
                }
                let sectionData = ExpensesSummarySection(id: sectionIndex, title: section.groupKey, entries: displayEntries)
                displaySections.append(sectionData)
            }
            return displaySections
        }
    }
    
    override func preferredNumberOfColumns() -> Int {
        return 1
    }

}
