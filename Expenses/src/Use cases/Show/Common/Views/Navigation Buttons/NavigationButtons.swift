//
//  NavigationButtons.swift
//  Expensit
//
//  Created by Borja Arias Drake on 07/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import Combine

struct NavigationButtonsView: View {

    // MARK: Private
    private var entryFormCoordinator: EntryFormNavigationCoordinator
    private var categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator
    @ObservedObject private var presenter: NavigationButtonsPresenter
    @State private var showEntryForm = false
    @State private var showCategoryFilter = false

    init(entryFormCoordinator: EntryFormNavigationCoordinator,
         categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator,
         presenter: NavigationButtonsPresenter) {
        self.entryFormCoordinator = entryFormCoordinator
        self.categoryFilterNavgationCoordinator = categoryFilterNavgationCoordinator
        self.presenter = presenter
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.showCategoryFilter.toggle()
            }) {
                Image(self.presenter.selectedCategoryImageName)
            }.sheet(isPresented: $showCategoryFilter) {
                self.categoryFilterNavgationCoordinator.categoryFilterView(forIdentifier:"", isPresented: self.$showCategoryFilter)
            }
            

            Button(action: {
                self.showEntryForm.toggle()
            }) {
                Image(systemName: "plus")
            }.sheet(isPresented: $showEntryForm) {
                self.entryFormCoordinator.entryFormView(forIdentifier:"", isPresented: self.$showEntryForm)
            }
        }
    }
}
