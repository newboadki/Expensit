//
//  CategoryFilterNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

class CategoryFilterNavigationCoordinator {
    private var coreDataFetchController: BSCoreDataFetchController
    private var selectedCategoryDataSource: CategoryDataSource
    
    init(coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: CategoryDataSource) {
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }
    
    func categoryFilterView(forIdentifier currentViewIdentifier: String, isPresented: Binding<Bool>) -> CategoryFilterView {
        let categoriesDataSource = CoreDataCategoryDataSource(coreDataController:self.coreDataFetchController.coreDataController)
        let categoriesInteractor = GetCategoriesInteractor(dataSource: categoriesDataSource)
        let filterByCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource)
        let presenter = CategoryFilterPresenter(categoriesInteractor: categoriesInteractor,
                                                filterByCategoryInteractor: filterByCategoryInteractor)
        return CategoryFilterView(presenter: presenter,
                                  isPresented: isPresented)
    }
}
