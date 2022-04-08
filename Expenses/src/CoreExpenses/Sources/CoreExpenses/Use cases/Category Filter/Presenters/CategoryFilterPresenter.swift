//
//  CategoryFilterPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public struct CategoryViewModel: Identifiable {
    public let id: Int
    public let name: String
}

@MainActor
public class CategoryFilterPresenter: ObservableObject {
    
    @Published
    public var selectedIndex: Int { didSet { filterBy(index: selectedIndex) } }
            
    @Published
    public var enumeratedCategories: [CategoryViewModel] = []
        
    // Private
    private var isPresented: Binding<Bool>
    private var categoriesCancellable = Set<AnyCancellable>()
    private var categoriesInteractor: GetCategoriesInteractor
    private var filterByCategoryInteractor: SetCategoryFilterInteractor
    private var categories: [ExpenseCategory] = [] { didSet { generateViewModels() } }

    // MAR: - Initializers
    public init(categoriesInteractor: GetCategoriesInteractor,
                filterByCategoryInteractor: SetCategoryFilterInteractor,
                isPresented: Binding<Bool>) {
        self.categoriesInteractor = categoriesInteractor
        self.filterByCategoryInteractor = filterByCategoryInteractor
        self.isPresented = isPresented
        
        if let stored = UserDefaults.standard.object(forKey: "selectedIndex") as? Int {
            self.selectedIndex = stored
        } else {
            self.selectedIndex = 0
        }
        
        self.categoriesInteractor.allCategories()
            .map({ listOfCategories in
                listOfCategories + [ExpenseCategory(name: "All", iconName: "filter_all", color: .black)]
            })
            .receive(on: RunLoop.main)
            .assign(to: \.categories, on: self)
            .store(in: &categoriesCancellable)
    }
    
    deinit {
        for item in categoriesCancellable {
            item.cancel()
        }
    }
    
    private func generateViewModels() {
        var array: [CategoryViewModel] = []
        for (idx, category) in categories.enumerated() {
            array.append(CategoryViewModel(id: idx, name: category.name))
        }
        enumeratedCategories = array
    }
    
    private func filterBy(index selectedIndex: Int) {
        UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        let selectedCategory = categories[selectedIndex]
        let optionalCategory = (selectedCategory.name == "All") ? nil : selectedCategory
        filterByCategoryInteractor.filter(by: optionalCategory)
        isPresented.wrappedValue = false
    }
}
