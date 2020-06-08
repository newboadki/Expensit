//
//  CategoryFilterInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class CategoryFilterInteractor {
    
    private var dataSource: SelectedCategoryDataSource
    
    init(dataSource: SelectedCategoryDataSource) {
        self.dataSource = dataSource
    }
    
    func filter(by category: ExpenseCategory?) {
        self.dataSource.selectedCategory = category
    }
}
