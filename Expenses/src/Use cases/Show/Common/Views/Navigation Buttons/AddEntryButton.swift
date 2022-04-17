//
//  AddEntryButton.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct AddEntryButton: View {
    // MARK: Private
    private var entryFormCoordinator: ExpensesEntryFormNavigationCoordinator
    @State private var showEntryForm = false

    // MARK: Initializers
    init(entryFormCoordinator: ExpensesEntryFormNavigationCoordinator) {
        self.entryFormCoordinator = entryFormCoordinator
    }
    
    var body: some View {
        Button(action: {
            self.showEntryForm.toggle()
        }) {
            Image(systemName: "plus")
        }.sheet(isPresented: $showEntryForm) {
            self.entryFormCoordinator.entryFormView(forIdentifier:"", isPresented: self.$showEntryForm)            
        }
    }
}



