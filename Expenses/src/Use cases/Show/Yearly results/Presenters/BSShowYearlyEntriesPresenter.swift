//
//  BSShowYearlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSShowYearlyEntriesPresenter : BSAbstractShowEntriesPresenter
{
    
    // MARK: From BSAbstractShowEntriesPresenter
    
    /// Transforms the CoreData query results into view-models adapted for a Yearly summary
    ///
    /// - Parameter data: CoreData query results
    /// - Returns: Array of view-models
    @objc override func displayDataFromEntriesForSummary(_ sections : [ExpensesGroup]) -> [BSDisplayExpensesSummarySection]
    {
        var displaySections = [BSDisplayExpensesSummarySection]()
        
        for section in sections
        {
            let entryEntities = section.entries
            
            for entryEntity in entryEntities
            {
                var displayEntries = [BSDisplayExpensesSummaryEntry]()
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
                
                let displayEntry = BSDisplayExpensesSummaryEntry(title: yearString as String , value: yearlySumString as String, signOfAmount: sign, date:nil, tag: nil)
                displayEntries.append(displayEntry)
                let sectionData = BSDisplayExpensesSummarySection(title: displayEntry.title, entries: displayEntries)
                displaySections.append(sectionData)
            }
        }
        
        return displaySections
    }
}
