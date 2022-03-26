//
//  GetCategoriesInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

public class GetCategoriesInteractor {
    
    private let dataSource: CategoryDataSource
    
    public init(dataSource: CategoryDataSource) {
        self.dataSource = dataSource
    }
    
    public func allCategories() -> AnyPublisher<[ExpenseCategory], Never> {
        return dataSource.allCategoriesPublisher.eraseToAnyPublisher()
    }
}
