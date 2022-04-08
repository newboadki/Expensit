//
//  CategoryFilterButtonView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct CategoryFilterButtonView: View {
    // MARK: Private
    private var categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator
    
    @ObservedObject
    private var presenter: NavigationButtonsPresenter
    
    @State
    private var showCategoryFilter = false

    init(categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator,
         presenter: NavigationButtonsPresenter) {
        self.categoryFilterNavgationCoordinator = categoryFilterNavgationCoordinator
        self.presenter = presenter
    }
    
    var body: some View {
        Button(action: {
            self.showCategoryFilter.toggle()
        }) {
            Image(self.presenter.selectedCategoryImageName)
        }.sheet(isPresented: $showCategoryFilter) {
            self.categoryFilterNavgationCoordinator.categoryFilterView(forIdentifier:"",
                                                                       isPresented: self.$showCategoryFilter)
        }
    }
}
