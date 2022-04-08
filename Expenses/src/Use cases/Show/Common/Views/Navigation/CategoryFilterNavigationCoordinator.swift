//
//  CategoryFilterNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses
import CoreData
import CoreDataPersistence

@MainActor
class CategoryFilterNavigationCoordinator {
    private var coreDataContext: NSManagedObjectContext
    private var selectedCategoryDataSource: CategoryDataSource
    
    init(coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }
    
    func categoryFilterView(forIdentifier currentViewIdentifier: String, isPresented: Binding<Bool>) -> CategoryFilterView {
        let categoriesDataSource = CoreDataCategoryDataSource(context: coreDataContext)
        let categoriesInteractor = GetCategoriesInteractor(dataSource: categoriesDataSource)
        let filterByCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource)
        let presenter = CategoryFilterPresenter(categoriesInteractor: categoriesInteractor,
                                                filterByCategoryInteractor: filterByCategoryInteractor,
                                                isPresented: isPresented)
        return CategoryFilterView(presenter: presenter,
                                  isPresented: isPresented)
    }
}
