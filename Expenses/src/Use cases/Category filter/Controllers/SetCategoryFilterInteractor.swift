//
//  CategoryFilterInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class SetCategoryFilterInteractor {
    
    private var dataSource: CategoryDataSource
    
    init(dataSource: CategoryDataSource) {
        self.dataSource = dataSource
    }
    
    func filter(by category: ExpenseCategory?) {
        self.dataSource.set(selectedCategory: category)
    }
}
