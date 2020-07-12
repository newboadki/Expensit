//
//  NavigationButtonsPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine
import CoreExpenses

class NavigationButtonsPresenter: ObservableObject {
    
    // MARK: Internal Properties
    @Published var selectedCategoryImageName: String
    
    // MARK: Private Properties
    private var selectedCategoryInteractor: SelectedCategoryInteractor
    private var selectedCategorySubscription: AnyCancellable?
    
    // MARK: Initializers
    init(selectedCategoryInteractor: SelectedCategoryInteractor) {
        self.selectedCategoryInteractor = selectedCategoryInteractor
        self.selectedCategoryImageName = "filter_all"
        self.bind()
    }
    
    private func bind() {
        selectedCategorySubscription = selectedCategoryInteractor.selectedCategory().sink { category in
            self.selectedCategoryImageName = (category?.iconName)?.replacingOccurrences(of: ".png", with: "") ?? "filter_all"
        }
    }
}
