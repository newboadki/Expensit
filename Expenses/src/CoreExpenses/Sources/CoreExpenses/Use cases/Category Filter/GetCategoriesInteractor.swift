//
//  GetCategoriesInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public class GetCategoriesInteractor {
    
    private var dataSource: CategoryDataSource
    
    public init(dataSource: CategoryDataSource) {
        self.dataSource = dataSource
    }
    
    public func allCategories() -> [ExpenseCategory] {
        return dataSource.allCategories()
    }
}
