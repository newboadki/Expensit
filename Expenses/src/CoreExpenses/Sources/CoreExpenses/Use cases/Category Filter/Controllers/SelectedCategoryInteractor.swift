//
//  SelectedCategoryInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

public class SelectedCategoryInteractor {
    
    private let dataSource: CategoryDataSource
    
    public init(dataSource: CategoryDataSource) {
        self.dataSource = dataSource
    }
    
    public func selectedCategory() -> Published<ExpenseCategory?>.Publisher {        
        return dataSource.selectedCategoryPublisher
    }
}

