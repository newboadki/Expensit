//
//  ExpensesSummaryNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 27/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses
import CoreData
import CoreDataPersistence
import Currencies

protocol NavigationCoordinator {
    associatedtype T: View
    
    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> T
}

class MainNavigationCoordinator: NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }
    
    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> ListView<YearlyExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: presenters["yearly"]!,
                        navigationButtonsPresenter: navigationButtonsPresenter,
                        title: "Yearly Breakdown",
                        navigationCoordinator: YearlyExpensesSummaryNavigationCoordinator(dataSources: dataSources,
                                                                                          presenters: presenters,
                                                                                          navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                          coreDataContext: self.coreDataContext,
                                                                                          selectedCategoryDataSource: selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataContext: self.coreDataContext),
                        categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataContext: self.coreDataContext,
                                                                                                selectedCategoryDataSource: self.selectedCategoryDataSource))
    }
}

// Tells you how to navigate to the next screen from the yearly summary
class YearlyExpensesSummaryNavigationCoordinator: NavigationCoordinator {
        
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> GridView<MonthlyExpensesSummaryNavigationCoordinator, CategoryPieChartNavigationCoordinator> {
        return GridView(presenter: presenters["monthly"]!,
                        columnCount: 3,
                        title: "Monthly Breakdown",
                        navigationButtonsPresenter: navigationButtonsPresenter,
                        navigationCoordinator:MonthlyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters,
                                                                                          navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                          coreDataContext: self.coreDataContext,
                                                                                          selectedCategoryDataSource: self.selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataContext: self.coreDataContext),
                        categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataContext:self.coreDataContext,
                                                                                                selectedCategoryDataSource: self.selectedCategoryDataSource),
                        headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(coreDataContext: self.coreDataContext))
    }
}

class MonthlyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> GridView<DailyExpensesSummaryNavigationCoordinator, CategoryPieChartNavigationCoordinator> {
        return GridView(presenter: presenters["daily"]!,
                        columnCount: 7,
                        title: "Daily Breakdown",
                        navigationButtonsPresenter: navigationButtonsPresenter,
                        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources,
                                                                                         presenters: presenters,
                                                                                         navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                         coreDataContext: self.coreDataContext,
                                                                                         selectedCategoryDataSource: self.selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataContext: self.coreDataContext),
                        categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataContext: self.coreDataContext,
                                                                                                selectedCategoryDataSource: self.selectedCategoryDataSource),
                        headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(coreDataContext: self.coreDataContext))
    }
}

class  DailyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataContext  = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> ListView<AllExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: presenters["all"]!,
                                  navigationButtonsPresenter: navigationButtonsPresenter,
                                  title: "All Entries",
                                  navigationCoordinator: AllExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters,
                                                                                                 navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                                 coreDataContext: self.coreDataContext,
                                                                                                 selectedCategoryDataSource: self.selectedCategoryDataSource),
                                  entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataContext: self.coreDataContext),
                        categoryFilterNavgationCoordinator:CategoryFilterNavigationCoordinator(coreDataContext: self.coreDataContext,
                                                                                               selectedCategoryDataSource: self.selectedCategoryDataSource))
    }
}

class AllExpensesSummaryNavigationCoordinator: NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }
    
    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> AddEntryFormView {
        let categoriesDataSource = CoreDataCategoryDataSource(context: coreDataContext)
        let categoriesInteractor = GetCategoriesInteractor(dataSource:categoriesDataSource)
        let individualEntryDataSource = IndividualExpensesDataSource(context: coreDataContext)
        let storageInteractor = AddExpenseInteractor(dataSource: individualEntryDataSource)
        let presenter = EntryFormPresenter(storageInteractor: storageInteractor,
                                               categoriesInteractor: categoriesInteractor,
                                               getExpenseInteractor: EntryForDateComponentsInteractor(dataSource: individualEntryDataSource), editExpenseInteractor: EditExpenseInteractor(dataSource: individualEntryDataSource),
                                               entryIdentifier: currentViewIdentifier,
                                               currencyCodesInteractor: SupportedCurrenciesInteractor(),
                                               exchangeRateInteractor: UpdateExpenseWithExchangeRateInteractor(dataSource: CurrencyExchangeRatesNetworkDataSource(), currenciesInteractor: SupportedCurrenciesInteractor()))
        return AddEntryFormView(presenter: presenter)
    }
}
