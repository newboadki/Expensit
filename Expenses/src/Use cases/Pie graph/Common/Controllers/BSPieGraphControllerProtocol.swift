//
//  BSPieGraphControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreExpenses

protocol BSPieGraphControllerProtocol
{
    func sortedTagsByPercentage(fromSections tags: [ExpenseCategory], sections : [PieChartSectionInfo]) -> [ExpenseCategory]?
    func categories(forMonth month: NSNumber?, year : NSNumber) async -> [ExpenseCategory]?
    func expensesByCategory(forMonth month: NSNumber?, year : NSNumber) async -> [PieChartSectionInfo]?
}
