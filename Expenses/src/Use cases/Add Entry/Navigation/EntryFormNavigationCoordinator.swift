//
//  EntryFormNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI


protocol EntryFormNavigationCoordinator {
    func entryFormView(forIdentifier currentViewIdentifier: String, isPresented: Binding<Bool>) -> EntryFormView
}


class ExpensesEntryFormNavigationCoordinator: EntryFormNavigationCoordinator {
    private var coreDataFetchController: BSCoreDataFetchController
    
    init(coreDataFetchController: BSCoreDataFetchController) {
        self.coreDataFetchController = coreDataFetchController
    }
    
    func entryFormView(forIdentifier currentViewIdentifier: String, isPresented: Binding<Bool>) -> EntryFormView {
        let categoriesDataSource = CategoriesDataSource(coreDataController:self.coreDataFetchController.coreDataController)
        let storageInteractor = BSAddEntryController(entryToEdit:nil,
                                                     coreDataFetchController:self.coreDataFetchController)
        let categoriesInteractor = GetCategoriesInteractor(dataSource:categoriesDataSource)
        let presenter = EntryFormPresenter(storageInteractor: storageInteractor,
                                           categoriesInteractor: categoriesInteractor)
        return EntryFormView(presenter: presenter,
                             beingPresented: isPresented)
    }
}
