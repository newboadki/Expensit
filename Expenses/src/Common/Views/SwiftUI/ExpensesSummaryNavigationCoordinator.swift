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


struct MainNavigationCoordinator: NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    
    func nextView(forIdentifier currentViewIdentifier: String) -> ListView<YearlyExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["yearly"]!)),
                        title: "Yearly Summary",
                        navigationCoordinator: YearlyExpensesSummaryNavigationCoordinator(dataSources: dataSources))
    }
}

// Tells you how to navigate to the next screen from the yearly summary
struct YearlyExpensesSummaryNavigationCoordinator: NavigationCoordinator {
        
    var dataSources: [String: EntriesSummaryDataSource]
    
    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<MonthlyExpensesSummaryNavigationCoordinator> {
        return GridView(presenter: ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["monthly"]!)),
                        columnCount: 3,
                        title: "Monthly Summary",
                        navigationCoordinator:MonthlyExpensesSummaryNavigationCoordinator(dataSources: dataSources))
    }
}

struct MonthlyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    
    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<DailyExpensesSummaryNavigationCoordinator> {
        return GridView(presenter: ShowDailyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["daily"]!)),
        columnCount: 7,
        title: "",
        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources))
    }
}

struct  DailyExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    
    func nextView(forIdentifier currentViewIdentifier: String) -> ListView<AllExpensesSummaryNavigationCoordinator> {
        return ListView(presenter: ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["daily"]!)),
                        title: "",
                        navigationCoordinator: AllExpensesSummaryNavigationCoordinator(dataSources: dataSources))
    }
}

struct AllExpensesSummaryNavigationCoordinator:NavigationCoordinator {
    
    var dataSources: [String: EntriesSummaryDataSource]
    
    func nextView(forIdentifier currentViewIdentifier: String) -> GridView<DailyExpensesSummaryNavigationCoordinator> {
        return GridView(presenter: ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: MockListDataSource())),
        columnCount: 4,
        title: "",
        navigationCoordinator: DailyExpensesSummaryNavigationCoordinator(dataSources: dataSources))
    }
}
