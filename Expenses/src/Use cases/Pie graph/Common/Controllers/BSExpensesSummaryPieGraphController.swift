//
//  BSExpensesSummaryPieGraphController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreExpenses

class BSExpensesSummaryPieGraphController : BSPieGraphControllerProtocol {
 
    private var dataProvider: CategoryDataSource
    
    public init(dataProvider: CategoryDataSource) {
        self.dataProvider = dataProvider
    }
    
    func sortedTagsByPercentage(fromSections tags: [ExpenseCategory], sections : [PieChartSectionInfo]) -> [ExpenseCategory]? {
        return self.dataProvider.sortedCategoriesByPercentage(fromCategories: tags, sections: sections)
    }
    
    func categories(forMonth month: NSNumber?, year : NSNumber) async -> [ExpenseCategory]? {
        return await self.dataProvider.categories(forMonth: month?.intValue, inYear: year.intValue)
    }
    
    func expensesByCategory(forMonth month: NSNumber?, year : NSNumber) async -> [PieChartSectionInfo]? {
        await self.dataProvider.expensesByCategory(forMonth: month?.intValue, inYear:year.intValue)
    }

}
