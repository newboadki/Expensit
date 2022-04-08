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

@MainActor
protocol NavigationCoordinator {
    associatedtype T: View
    
    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> T
}
@MainActor
class MainNavigationCoordinator: NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractAppPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractAppPresenter],
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
    var presenters: [String: AbstractAppPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractAppPresenter],
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
                        headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(coreDataContext: self.coreDataContext),
                        targetDestination: currentViewIdentifier)
    }
}

class MonthlyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractAppPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractAppPresenter],
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
                        headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(coreDataContext: self.coreDataContext),
                        targetDestination: currentViewIdentifier)
    }
}

class  DailyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractAppPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractAppPresenter],
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
                                                                                               selectedCategoryDataSource: self.selectedCategoryDataSource),
                        targetDestination: currentViewIdentifier)
    }
}

class AllExpensesSummaryNavigationCoordinator: NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractAppPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataContext: NSManagedObjectContext
    var selectedCategoryDataSource: CategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractAppPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataContext: NSManagedObjectContext,
         selectedCategoryDataSource: CategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataContext = coreDataContext
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }
    
    func nextView(forIdentifier currentViewIdentifier: DateComponents?) -> EditEntryFormView {
        let categoriesDataSource = CoreDataCategoryDataSource(context: coreDataContext)
        let categoriesInteractor = GetCategoriesInteractor(dataSource:categoriesDataSource)
        let individualEntryDataSource = IndividualExpensesDataSource(context: coreDataContext)
        let storageInteractor = AddExpenseInteractor(dataSource: individualEntryDataSource)
        let presenter = EntryFormPresenter(storageInteractor: storageInteractor,
                                               categoriesInteractor: categoriesInteractor,
                                               getExpenseInteractor: EntryForDateComponentsInteractor(dataSource: individualEntryDataSource), editExpenseInteractor: EditExpenseInteractor(dataSource: individualEntryDataSource),
                                               deleteExpenseInteractor: DeleteExpenseInteractor(dataSource: individualEntryDataSource),
                                               entryIdentifier: currentViewIdentifier,
                                               currencyCodesInteractor: SupportedCurrenciesInteractor(),
                                               exchangeRateInteractor: UpdateExpenseWithExchangeRateInteractor(dataSource: CurrencyExchangeRatesDataSourceMapper(dataSource: CurrencyExchangeRatesNetworkDataSource()), currenciesInteractor: SupportedCurrenciesInteractor()))
        return EditEntryFormView(presenter: presenter)
    }
}
