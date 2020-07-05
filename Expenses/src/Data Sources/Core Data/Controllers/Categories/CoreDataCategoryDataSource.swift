//
//  CoreDataCategoryDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

class CoreDataCategoryDataSource: CategoryDataSource {
        
    @Published var selectedCategory: ExpenseCategory?
    var selectedCategoryPublished : Published<ExpenseCategory?> {_selectedCategory}
    var selectedCategoryPublisher : Published<ExpenseCategory?>.Publisher {$selectedCategory}

    
    private var coreDataController: BSCoreDataController

    init(coreDataController: BSCoreDataController) {
        self.coreDataController = coreDataController
    }
    
    func allCategories() -> [ExpenseCategory] {
        self.coreDataController.allTags().map { coreDataTag in
            ExpenseCategory(name: coreDataTag.name,
                            iconName: coreDataTag.iconName,
                            color: coreDataTag.color)
        }
    }
    
    func set(selectedCategory: ExpenseCategory?) {
        self.selectedCategory = selectedCategory
    }
}
