//
//  ExpensesSummaryNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 27/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI



protocol NavigationCoordinator {
    associatedtype T: View
    
    func nextView(forIdentifier currentViewIdentifier: String) -> T
}


class MainNavigationCoordinator: NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }
    
    func nextView(forIdentifier currentViewIdentifier: String) -> ListView<YearlyExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: presenters["yearly"]!,
                        navigationButtonsPresenter: navigationButtonsPresenter,
                        title: "Yearly Breakdown",
                        navigationCoordinator: YearlyExpensesSummaryNavigationCoordinator(dataSources: dataSources,
                                                                                          presenters: presenters,
                                                                                          navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                          coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController),
                        categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
                                                                                                selectedCategoryDataSource: self.selectedCategoryDataSource))
    }
}

// Tells you how to navigate to the next screen from the yearly summary
class YearlyExpensesSummaryNavigationCoordinator: NavigationCoordinator {
        
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<MonthlyExpensesSummaryNavigationCoordinator, CategoryPieChartNavigationCoordinator> {
        return GridView(presenter: presenters["monthly"]!,
                        columnCount: 3,
                        title: "Monthly Breakdown",
                        navigationButtonsPresenter: navigationButtonsPresenter,
                        navigationCoordinator:MonthlyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters,
                                                                                          navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                          coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController),
                        categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
                                                                                                selectedCategoryDataSource: self.selectedCategoryDataSource),
                        headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(fetchController: self.coreDataFetchController))
    }
}

class MonthlyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<DailyExpensesSummaryNavigationCoordinator, CategoryPieChartNavigationCoordinator> {
        return GridView(presenter: presenters["daily"]!,
        columnCount: 7,
        title: "Daily Breakdown",
        navigationButtonsPresenter: navigationButtonsPresenter,
        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters,
                                                                         navigationButtonsPresenter: navigationButtonsPresenter,
                                                                         coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource), entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController), categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
                                                                                                                                                                                                                                                                                                                                                                                           selectedCategoryDataSource: self.selectedCategoryDataSource), headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(fetchController: self.coreDataFetchController))
    }
}

class  DailyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> ListView<AllExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: presenters["all"]!,
                        navigationButtonsPresenter: navigationButtonsPresenter,
                        title: "All Entries",
                        navigationCoordinator: AllExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters,
                                                                                       navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                       coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource), entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController),
                        categoryFilterNavgationCoordinator:CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
                                                                                               selectedCategoryDataSource: self.selectedCategoryDataSource))
    }
}

class AllExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var navigationButtonsPresenter: NavigationButtonsPresenter
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         navigationButtonsPresenter: NavigationButtonsPresenter,
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<DailyExpensesSummaryNavigationCoordinator, CategoryPieChartNavigationCoordinator> {
        return GridView(presenter: presenters["all"]!,
        columnCount: 4,
        title: "",
        navigationButtonsPresenter: navigationButtonsPresenter,
        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters,
                                                                         navigationButtonsPresenter: navigationButtonsPresenter,
                                                                         coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource), entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController), categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
        selectedCategoryDataSource: self.selectedCategoryDataSource),
        headerViewNavigationCoordinator: CategoryPieChartNavigationCoordinator(fetchController: self.coreDataFetchController))
    }
}
