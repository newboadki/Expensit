//
//  CategoryFilterPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

public class CategoryFilterPresenter {
    
    // Internal
    public var selectedIndex: Int {
        didSet {
            UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
            let selectedCategory = categories[selectedIndex]
            let optionalCategory = (selectedCategory.name == "All") ? nil : selectedCategory
            filterByCategoryInteractor.filter(by: optionalCategory)
        }
    }
    
    @Published
    public var categoryNames: [String] = []
    private var categoryNamesCancellable = Set<AnyCancellable>()

    @Published
    public var categories: [ExpenseCategory] = []
    private var categoriesCancellable = Set<AnyCancellable>()

    // Private
    private var categoriesInteractor: GetCategoriesInteractor
    private var filterByCategoryInteractor: SetCategoryFilterInteractor
    
    // MAR: - Initializers
    public init(categoriesInteractor: GetCategoriesInteractor,
                filterByCategoryInteractor: SetCategoryFilterInteractor) {
        self.categoriesInteractor = categoriesInteractor
        self.filterByCategoryInteractor = filterByCategoryInteractor
        if let stored = UserDefaults.standard.object(forKey: "selectedIndex") as? Int {
            self.selectedIndex = stored
        } else {
            self.selectedIndex = 0
        }
        
        self.categoriesInteractor.allCategories()
            .map({ listOfCategories in
                listOfCategories.map { $0.name }
            })
            .map({ listOfCategoryNames in
                listOfCategoryNames + ["All"]
            })
            .assign(to: \.categoryNames, on: self)
            .store(in: &categoryNamesCancellable)
        
        self.categoriesInteractor.allCategories()
            .map({ listOfCategories in
                listOfCategories + [ExpenseCategory(name: "All", iconName: "filter_all", color: .black)]
            })
            .assign(to: \.categories, on: self)
            .store(in: &categoriesCancellable)
    }
}
