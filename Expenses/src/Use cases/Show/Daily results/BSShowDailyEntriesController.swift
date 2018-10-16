//
//  BSShowDailyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSShowDailyEntriesController : NSObject, BSAbstractShowEntriesControllerProtocol {
    
    private var dataProvider: BSCoreDataFetchController
    
    public init(dataProvider: BSCoreDataFetchController) {
        self.dataProvider = dataProvider
    }
    
    func filter(by category: ExpenseCategory?) {
        self.dataProvider.filter(summaryType:.daily, by: category)
    }
    
    func entriesForSummary() -> [ExpensesGroup] {
        return self.dataProvider.entriesGroupedByDay()
    }
    
    func image(for category: ExpenseCategory?) -> UIImage? {
        return self.dataProvider.image(for: category)
    }
}
