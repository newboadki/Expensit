//
//  BSExpensesSummaryPieGraphPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 11/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreExpenses

class BSExpensesSummaryPieGraphPresenter : NSObject, BSPieGraphPresenterProtocol
{
    let pieGraphController : BSPieGraphControllerProtocol
    let month : NSNumber?
    let year : NSNumber
    
    init(pieGraphController: BSPieGraphControllerProtocol, month: NSNumber?, year: NSNumber)
    {
        self.pieGraphController = pieGraphController
        self.month = month
        self.year = year
        super.init()
    }
    
    func categories() -> [ExpenseCategory]? {
        let sections = self.sections()
        let categories = self.pieGraphController.categories(forMonth: self.month, year: self.year)
        return self.pieGraphController.sortedTagsByPercentage(fromSections: categories!, sections: sections!)
    }
    
    func sections() -> [PieChartSectionInfo]? {
        return self.pieGraphController.expensesByCategory(forMonth: self.month, year: self.year)
    }
    
}
