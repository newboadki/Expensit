//
//  Categories.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

public protocol CategoryDataSource {
    var selectedCategoryPublisher: Published<ExpenseCategory?>.Publisher {get}
    var allCategoriesPublisher: Published<[ExpenseCategory]>.Publisher {get}
    func set(selectedCategory: ExpenseCategory?)    
    func sortedCategoriesByPercentage(fromCategories categories: [ExpenseCategory],
                                      sections: [PieChartSectionInfo]) -> [ExpenseCategory]
    func categories(forMonth month: Int?, inYear year: Int) async -> [ExpenseCategory]
    func expensesByCategory(forMonth month: Int?, inYear year: Int) async -> [PieChartSectionInfo]
    
    /// Creates the categories in the context and saves them according to the parameter
    func create(categories: [String], save: Bool) async throws
}
