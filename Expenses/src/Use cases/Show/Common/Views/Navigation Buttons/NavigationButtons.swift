//
//  NavigationButtons.swift
//  Expensit
//
//  Created by Borja Arias Drake on 07/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct NavigationButtonsView: View {

    @State private var showEntryForm = false
    @State private var showCategoryFilter = false
    
    var entryFormCoordinator: EntryFormNavigationCoordinator
    var categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator

    init(entryFormCoordinator: EntryFormNavigationCoordinator,
         categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator) {
        self.entryFormCoordinator = entryFormCoordinator
        self.categoryFilterNavgationCoordinator = categoryFilterNavgationCoordinator
    }
    
    var body: some View {
        HStack {
            Button("F") {
                self.showCategoryFilter.toggle()
            }.sheet(isPresented: $showCategoryFilter) {
                self.categoryFilterNavgationCoordinator.categoryFilterView(forIdentifier:"", isPresented: self.$showCategoryFilter)
            }

            Button("+") {
                self.showEntryForm.toggle()
                print("Showing entry: \(self.showEntryForm)")
            }.sheet(isPresented: $showEntryForm) {
                self.entryFormCoordinator.entryFormView(forIdentifier:"", isPresented: self.$showEntryForm)
            }

        }

    }
}
