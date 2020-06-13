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
            UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
            let selectedCategory = categories[selectedIndex]
            let optionalCategory = (selectedCategory.name == "All") ? nil : selectedCategory
            filterByCategoryInteractor.filter(by: optionalCategory)
        }
    }
    
    lazy var categoryNames: [String] = {
        var r = self.categoriesInteractor.allCategories().map { expenseCategory in
            return expenseCategory.name
        }
        r.append("All")
        return r
    }()

    lazy var categories: [ExpenseCategory] = {
        var r = self.categoriesInteractor.allCategories()
        r.append(ExpenseCategory(name: "All", iconName: "filter_all", color: .black))
        return r
    }()

    // Private
    private var categoriesInteractor: GetCategoriesInteractor
    private var filterByCategoryInteractor: SetCategoryFilterInteractor
    
    // MAR: - Initializers
    init(categoriesInteractor: GetCategoriesInteractor,
         filterByCategoryInteractor: SetCategoryFilterInteractor) {
        self.categoriesInteractor = categoriesInteractor
        self.filterByCategoryInteractor = filterByCategoryInteractor
        if let stored = UserDefaults.standard.object(forKey: "selectedIndex") as? Int {
            self.selectedIndex = stored
        } else {
            self.selectedIndex = 0
        }
    }
}
