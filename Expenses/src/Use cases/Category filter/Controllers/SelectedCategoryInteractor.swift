//
//  SelectedCategoryInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class SelectedCategoryInteractor {
    
    private var dataSource: SelectedCategoryDataSource
    
    init(dataSource: SelectedCategoryDataSource) {
        self.dataSource = dataSource
    }
    
    func selectedCategory() -> Published<ExpenseCategory?>.Publisher {        
        return dataSource.$selectedCategory
    }
}

