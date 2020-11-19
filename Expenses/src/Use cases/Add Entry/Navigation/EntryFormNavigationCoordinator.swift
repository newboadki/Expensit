//
//  EntryFormNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses
import CoreData
import CoreDataPersistence
import Currencies

protocol EntryFormNavigationCoordinator {
    func entryFormView(forIdentifier currentViewIdentifier: String, isPresented: Binding<Bool>) -> AddEntryFormView
}


class ExpensesEntryFormNavigationCoordinator: EntryFormNavigationCoordinator {
    private var coreDataContext: NSManagedObjectContext
    
    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
    
    func entryFormView(forIdentifier currentViewIdentifier: String, isPresented: Binding<Bool>) -> AddEntryFormView {
        let categoriesDataSource = CoreDataCategoryDataSource(context: self.coreDataContext)
        let categoriesInteractor = GetCategoriesInteractor(dataSource:categoriesDataSource)
        let individualEntryDataSource = IndividualExpensesDataSource(context: self.coreDataContext)
        let storageInteractor = AddExpenseInteractor(dataSource: individualEntryDataSource)
        let presenter = EntryFormPresenter(storageInteractor: storageInteractor,
                                           categoriesInteractor: categoriesInteractor,
                                           getExpenseInteractor: EntryForDateComponentsInteractor(dataSource: individualEntryDataSource),
                                           editExpenseInteractor: EditExpenseInteractor(dataSource: individualEntryDataSource),
                                           deleteExpenseInteractor: DeleteExpenseInteractor(dataSource: individualEntryDataSource),
                                           currencyCodesInteractor: SupportedCurrenciesInteractor(),
                                           exchangeRateInteractor: UpdateExpenseWithExchangeRateInteractor(dataSource: CurrencyExchangeRatesNetworkDataSource(), currenciesInteractor: SupportedCurrenciesInteractor()))
        return AddEntryFormView(presenter: presenter)
    }
}
