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
import WatchConnectivity

class SceneDelegate: UIResponder, UIWindowSceneDelegate, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let individualEntryDataSource = IndividualExpensesDataSource(context: context)
        let storageInteractor = AddExpenseInteractor(dataSource: individualEntryDataSource)

        let d = Date()
        let dateComponents = DateComponents(year: d.component(.year),
                                        month: d.component(.month),
                                        day: d.component(.day),
                                        hour: d.component(.hour),
                                        minute: d.component(.minute),
                                        second: d.component(.second))
        
        DispatchQueue.main.async {
            let r = storageInteractor.add(expense: Expense(dateComponents: dateComponents,
                                                           date: Date(),
                                                           value: 100,
                                                           description: "A new one!",
                                                           category: ExpenseCategory(name: "Bills",
                                                                                     iconName: "",
                                                                                     color: .black)))

        }
    }


    var window: UIWindow?
    var presenter: ShowYearlyEntriesPresenter!
    var context: NSManagedObjectContext!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        // Initialize CoreData's Stack
        CoreDataStack.context { result in
            switch result {
                case .failure(let coreDataError):
                    print(coreDataError)
                case .success(let context):
                    self.context = context
            }
        }

        // Dependency injection
        let selectedCategoryDataSource = CoreDataCategoryDataSource(context: self.context)
        
        let migrationManager = CoreDataModelMigrationsInteractor(categoryDataSource: selectedCategoryDataSource)
        migrationManager.applyPendingMigrations(to: CoreDataStack.model())
        
        
        let dataSources: [String: EntriesSummaryDataSource] = ["yearly" : YearlyCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                           selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "monthly" : MonthlyCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                             selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "daily" : DailyCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                         selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "all" : AllEntriesCoreDataExpensesDataSource(coreDataContext:self.context,
                                                                                                            selectedCategoryDataSource: selectedCategoryDataSource)]

        let presenters: [String: AbstractEntriesSummaryPresenter] = ["yearly" : ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["yearly"]!)),
                                                               "monthly" : ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["monthly"]!)),
                                                               "daily" : ShowDailyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["daily"]!)),
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

