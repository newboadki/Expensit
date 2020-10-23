//
//  SceneDelegate.swift
//  SwiftUICommbine
//
//  Created by Borja Arias Drake on 19/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import UIKit
import SwiftUI
import CoreExpenses
import CoreData
import CoreDataPersistence
import DateAndTime

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var presenter: ShowYearlyEntriesPresenter!
    var context: NSManagedObjectContext!
    private static let semaphore = DispatchSemaphore(value: 1)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        
        // Initialize CoreData's Stack
        CoreDataStack.context { result in
            switch result {
                case .failure(let coreDataError):
                    print(coreDataError)
                case .success(let context):
                    self.context = context
            }
            SceneDelegate.semaphore.signal()
        }
        SceneDelegate.semaphore.wait()

        // Dependency injection
        let selectedCategoryDataSource = CoreDataCategoryDataSource(context: self.context)
        let individualEntriesDataSource = IndividualExpensesDataSource(context: self.context)
                
        let migrationManager = CoreDataModelMigrationsInteractor(categoryDataSource: selectedCategoryDataSource,
                                                                 individualEntriesDataSource: IndividualExpensesDataSource(context: self.context))
        migrationManager.applyPendingMigrations(to: CoreDataStack.model())

        populate(expensesDS: individualEntriesDataSource, categoriesDS: selectedCategoryDataSource)

        let dataSources: [String: EntriesSummaryDataSource] = ["yearly" : YearlyCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                           selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "monthly" : MonthlyCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                             selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "daily" : DailyCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                         selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "all" : AllEntriesCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                            selectedCategoryDataSource: selectedCategoryDataSource)]

        let presenters: [String: AbstractEntriesSummaryPresenter] = ["yearly" : ShowYearlyEntriesPresenter(interactor: YearlyExpensesSummaryInteractor(dataSource: dataSources["yearly"]!)),
                                                               "monthly" : ShowMonthlyEntriesPresenter(interactor: MonthlyExpensesSummaryInteractor(dataSource: dataSources["monthly"]!)),
                                                               "daily" : ShowDailyEntriesPresenter(interactor: DailyExpensesSummaryInteractor(dataSource: dataSources["daily"]!)),
                                                               "all" : ShowAllEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["all"]!))]

        let navigationButtonsPresenter = NavigationButtonsPresenter(selectedCategoryInteractor: SelectedCategoryInteractor(dataSource: selectedCategoryDataSource))
        let contentView = ExpensesSummaryNavigationView(navigationCoordinator: MainNavigationCoordinator(dataSources:dataSources,
                                                                                                         presenters: presenters,
                                                                                                         navigationButtonsPresenter: navigationButtonsPresenter,
                                                                                                         coreDataContext: self.context,
            selectedCategoryDataSource: selectedCategoryDataSource))
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

private extension SceneDelegate {
    
    func populate(expensesDS: IndividualExpensesDataSource, categoriesDS: CoreDataCategoryDataSource) {
        let dc1 = DateComponents(year: 2020, month: 07, day: 07, hour: 14, minute: 33, second: 25)
        _ = expensesDS.add(expense: Expense(dateComponents: dc1,
                                            date: DateConversion.date(withFormat: DateFormats.defaultFormat, from: "07/07/2020"),
                                            value: 500,
                                            description: "Gift",
                                            category: categoriesDS.category(for: "Income"),
                                            currencyCode: "GBP",
                                            exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.5")))

        let dc2 = DateComponents(year: 2020, month: 01, day: 01, hour: 14, minute: 33, second: 25)
        _ = expensesDS.add(expense: Expense(dateComponents: dc2,
                                            date: DateConversion.date(withFormat: DateFormats.defaultFormat, from: "01/01/2020"),
                                            value: 15000,
                                            description: "Gift",
                                            category: categoriesDS.category(for: "Income"),
                                            currencyCode: "USD",
                                            exchangeRateToBaseCurrency: NSDecimalNumber(string: "1.0")))

    }
}
