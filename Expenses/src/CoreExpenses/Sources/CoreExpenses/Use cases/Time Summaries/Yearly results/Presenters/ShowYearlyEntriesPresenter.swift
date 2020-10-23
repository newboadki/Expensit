//
//  ShowYearlyEntriesPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

public class ShowYearlyEntriesPresenter: AbstractEntriesSummaryPresenter {
                
    public override var title: String {
        get {"Yearly Breakdown" }
        
        set{ super.title = newValue}
        
    }

    public override func displayDataFromEntriesForSummary() -> AnyPublisher<[ExpensesSummarySectionViewModel], Never> {
                        
        print("Yearly Presenter called.")
        return self.interactor.entriesForSummary().map { expensesGroups in
            let groups = expensesGroups as [ExpensesGroup]
            var displaySections = [ExpensesSummarySectionViewModel]()
            
            for section in groups
            {
                let entryEntities = section.entries
                var displayEntries = [ExpensesSummaryEntryViewModel]()
                for entryEntity in entryEntities
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
                    let yearlySumString = DefaultExpenseCurrencyFormatter.amountFormatter().string(from: value)!
                    let displayEntry = ExpensesSummaryEntryViewModel(id: entryEntity.dateComponents,
                                                                     title: yearString as String,
                                                                     value: yearlySumString as String,
                                                                     signOfAmount: sign,
                                                                     date:nil,
                                                                     tag: nil,
                                                                     currencyCode: "")
                    displayEntries.append(displayEntry)
                }
                
                let sectionData = ExpensesSummarySectionViewModel(id:section.groupKey, title: "", entries: displayEntries)
                displaySections.append(sectionData)
            }
            return displaySections
        }.eraseToAnyPublisher()
    }
    
    public override func preferredNumberOfColumns() -> Int {
        return 1
    }

}
