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
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }
    
    func nextView(forIdentifier currentViewIdentifier: String) -> ListView<YearlyExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: presenters["yearly"]!,
                        title: "Yearly Breakdown",
                        navigationCoordinator: YearlyExpensesSummaryNavigationCoordinator(dataSources: dataSources,
                                                                                          presenters: presenters, coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController),
                        categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
                                                                                                selectedCategoryDataSource: self.selectedCategoryDataSource))
    }
}

// Tells you how to navigate to the next screen from the yearly summary
class YearlyExpensesSummaryNavigationCoordinator: NavigationCoordinator {
        
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<MonthlyExpensesSummaryNavigationCoordinator> {
        return GridView(presenter: presenters["monthly"]!,
                        columnCount: 3,
                        title: "Monthly Breakdown",
                        navigationCoordinator:MonthlyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters, coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource),
                        entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController))
    }
}

class MonthlyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<DailyExpensesSummaryNavigationCoordinator> {
        return GridView(presenter: presenters["daily"]!,
        columnCount: 7,
        title: "Daily Breakdown",
        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters, coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource), entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController))
    }
}

class  DailyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> ListView<AllExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: presenters["all"]!,
                        title: "All Entries",
                        navigationCoordinator: AllExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters, coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource), entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController),
                        categoryFilterNavgationCoordinator:CategoryFilterNavigationCoordinator(coreDataFetchController: self.coreDataFetchController,
                                                                                               selectedCategoryDataSource: self.selectedCategoryDataSource))
    }
}

class AllExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    var presenters: [String: AbstractEntriesSummaryPresenter]
    var coreDataFetchController: BSCoreDataFetchController
    var selectedCategoryDataSource: SelectedCategoryDataSource
    
    init(dataSources: [String: EntriesSummaryDataSource],
         presenters: [String: AbstractEntriesSummaryPresenter],
         coreDataFetchController: BSCoreDataFetchController,
         selectedCategoryDataSource: SelectedCategoryDataSource) {
        self.dataSources = dataSources
        self.presenters = presenters
        self.coreDataFetchController = coreDataFetchController
        self.selectedCategoryDataSource = selectedCategoryDataSource
    }

    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<DailyExpensesSummaryNavigationCoordinator> {
        return GridView(presenter: presenters["all"]!,
        columnCount: 4,
        title: "",
        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources, presenters: presenters, coreDataFetchController: self.coreDataFetchController, selectedCategoryDataSource: self.selectedCategoryDataSource), entryFormCoordinator: ExpensesEntryFormNavigationCoordinator(coreDataFetchController: self.coreDataFetchController))
    }
}
