//
//  Categories.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

protocol CategoryDataSource {
    var selectedCategoryPublisher: Published<ExpenseCategory?>.Publisher {get}
    func set(selectedCategory: ExpenseCategory?)
    func allCategories() -> [ExpenseCategory]    
}
