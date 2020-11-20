//
//  Categories.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public protocol CategoryDataSource {
    var selectedCategoryPublisher: Published<ExpenseCategory?>.Publisher {get}
    func set(selectedCategory: ExpenseCategory?)
    func allCategories() -> [ExpenseCategory]
    func sortedCategoriesByPercentage(fromCategories categories: [ExpenseCategory],
                                      sections: [PieChartSectionInfo]) -> [ExpenseCategory]
    func categories(forMonth month: Int?, inYear year: Int) -> [ExpenseCategory]
    func expensesByCategory(forMonth month: Int?, inYear year: Int) -> [PieChartSectionInfo]
    func create(categories: [String]) -> Result<Bool, Error>
}
