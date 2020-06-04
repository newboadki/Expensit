//
//  GetCategoriesInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class GetCategoriesInteractor {
    
    private var dataSource: CategoriesDataSource
    
    init(dataSource: CategoriesDataSource) {
        self.dataSource = dataSource
    }
    
    func allCategories() -> [ExpenseCategory] {
        return dataSource.allCategories()
    }
}
