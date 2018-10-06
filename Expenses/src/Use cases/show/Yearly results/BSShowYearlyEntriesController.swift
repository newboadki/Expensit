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
    
    func filter(by category: BSExpenseCategory?) {
        self.dataProvider.filter(summaryType:.yearly, by: category)
    }
    
    func entriesForSummary() -> [BSEntryEntityGroup] {
        return self.dataProvider.entriesGroupedByYear()
    }
    
    func image(for category: BSExpenseCategory?) -> UIImage? {
        return self.dataProvider.image(for: category)
    }
    
}
