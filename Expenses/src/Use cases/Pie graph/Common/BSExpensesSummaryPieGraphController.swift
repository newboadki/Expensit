//
//  BSExpensesSummaryPieGraphController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSExpensesSummaryPieGraphController : BSPieGraphControllerProtocol {
 
    private var dataProvider: BSCoreDataFetchController
    
    public init(dataProvider: BSCoreDataFetchController) {
        self.dataProvider = dataProvider
    }
    
    func sortedTagsByPercentage(fromSections tags: [BSExpenseCategory], sections : [BSPieChartSectionInfo]) -> [BSExpenseCategory]? {
        return self.dataProvider.sortedCategoriesByPercentage(fromCategories: tags, sections: sections)
    }
    
    // make month nil
    func categories(forMonth month: NSNumber?, year : NSNumber) -> [BSExpenseCategory]? {
        return self.dataProvider.categories(forMonth: month, inYear: year)
    }
    
    func expensesByCategory(forMonth month: NSNumber?, year : NSNumber) -> [BSPieChartSectionInfo]? {
        return self.dataProvider.expensesByCategory(forMonth: month, inYear:year)
    }

}
