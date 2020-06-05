//
//  CategoryFilterPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class CategoryFilterPresenter {
    
    // Internal
    var selectedIndex: Int {
        didSet {
            print("------")
            UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
            let selectedCategory = categories[selectedIndex]
            filterByCategoryInteractor.filter(by: selectedCategory)
        }
    }
    
    lazy var categoryNames: [String] = {
        self.categoriesInteractor.allCategories().map { expenseCategory in
            return expenseCategory.name
        }
    }()

    lazy var categories: [ExpenseCategory] = {
        self.categoriesInteractor.allCategories()
    }()

    // Private
    private var categoriesInteractor: GetCategoriesInteractor
    private var filterByCategoryInteractor: CategoryFilterInteractor
    
    // MAR: - Initializers
    init(categoriesInteractor: GetCategoriesInteractor,
         filterByCategoryInteractor: CategoryFilterInteractor) {
        self.categoriesInteractor = categoriesInteractor
        self.filterByCategoryInteractor = filterByCategoryInteractor
        if let stored = UserDefaults.standard.object(forKey: "selectedIndex") as? Int {
            self.selectedIndex = stored
        } else {
            self.selectedIndex = 0
        }
        
        
        
    }
}
