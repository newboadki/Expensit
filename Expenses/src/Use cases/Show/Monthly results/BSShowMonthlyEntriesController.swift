//
//  BSShowMonthlyEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc class BSShowMonthlyEntriesController : NSObject, BSAbstractShowEntriesControllerProtocol {
    
    private var dataProvider: BSCoreDataFetchController
    
    
    // MARK: - Initializers
    
    public init(dataProvider: BSCoreDataFetchController) {
        self.dataProvider = dataProvider
    }
    
    
    // MARK: - BSAbstractShowEntriesControllerProtocol
    
    func filter(by category: ExpenseCategory?) {
        self.dataProvider.filter(summaryType:.monthly, by: category)
    }
    
    func entriesForSummary() -> [ExpensesGroup] {
        return self.dataProvider.entriesGroupedByMonth()
    }
    
    func image(for category: ExpenseCategory?) -> UIImage? {
        return self.dataProvider.image(for: category)
    }
    
}
