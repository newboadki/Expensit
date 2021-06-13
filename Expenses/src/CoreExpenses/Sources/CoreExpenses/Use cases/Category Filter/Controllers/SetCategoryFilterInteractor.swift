//
//  CategoryFilterInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public class SetCategoryFilterInteractor {
    
    private let dataSource: CategoryDataSource
    
    public init(dataSource: CategoryDataSource) {
        self.dataSource = dataSource
    }
    
    public func filter(by category: ExpenseCategory?) {
        self.dataSource.set(selectedCategory: category)
    }
}
