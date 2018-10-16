//
//  BSShowYearlyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSShowYearlyEntriesController : NSObject, BSAbstractShowEntriesControllerProtocol {
        
    private var dataProvider: BSCoreDataFetchController
    
    public init(dataProvider: BSCoreDataFetchController) {
        self.dataProvider = dataProvider
    }
    
    func filter(by category: ExpenseCategory?) {
        self.dataProvider.filter(summaryType:.yearly, by: category)
    }
    
    func entriesForSummary() -> [ExpensesGroup] {
        return self.dataProvider.entriesGroupedByYear()
    }
    
    func image(for category: ExpenseCategory?) -> UIImage? {
        return self.dataProvider.image(for: category)
    }
    
}
