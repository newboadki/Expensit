//
//  SceneDelegate.swift
//  SwiftUICommbine
//
//  Created by Borja Arias Drake on 19/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var presenter: ShowYearlyEntriesPresenter!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        
        let coreDataStackHelper = CoreDataStackHelper(persitentStoreType: NSSQLiteStoreType,
                                                      resourceName: "Expenses",
                                                      extension: "momd",
                                                      persistentStoreName: "expensesDataBase")
        let coreDataController = BSCoreDataController(entityName: "Entry", coreDataHelper: coreDataStackHelper!)
        coreDataController.coreDataHelper = coreDataStackHelper!
        
//        let tag = coreDataController.tag(forName: "Food")
//        coreDataController.insertNewEntry(with: DateTimeHelper.date(withFormat: "dd/MM/yyyy", stringDate: "05/06/2020"), description: "Have a good one!", value: "90", category: tag)
//        
//        coreDataController.insertNewEntry(with: DateTimeHelper.date(withFormat: "dd/MM/yyyy", stringDate: "07/12/2019"), description: "Dinner", value: "3550", category: nil)
//        coreDataController.insertNewEntry(with: DateTimeHelper.date(withFormat: "dd/MM/yyyy", stringDate: "25/01/2014"), description: "Aniversary", value: "-1000", category: nil)
        
        let migrationManager = BSCoreDataFixturesManager()
        migrationManager.applyMissingFixtures(on: coreDataStackHelper?.managedObjectModel, coreDataController: coreDataController)
//        BSCoreDataFixturesManager *manager = [[BSCoreDataFixturesManager alloc] init];
//        [manager applyMissingFixturesOnManagedObjectModel:self.coreDataHelper.managedObjectModel coreDataController:coreDataController];


        let selectedCategoryDataSource = SelectedCategoryDataSource()
        let dataSources: [String: EntriesSummaryDataSource] = ["yearly" : YearlyCoreDataExpensesDataSource(coreDataController:coreDataController,
                                                                                                           selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "monthly" : MonthlyCoreDataExpensesDataSource(coreDataController:coreDataController,
                                                                                                             selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "daily" : DailyCoreDataExpensesDataSource(coreDataController:coreDataController,
                                                                                                         selectedCategoryDataSource: selectedCategoryDataSource),
                                                               "all" : AllEntriesCoreDataExpensesDataSource(coreDataController: coreDataController,
                                                                                                            selectedCategoryDataSource: selectedCategoryDataSource)]

        let presenters: [String: AbstractEntriesSummaryPresenter] = ["yearly" : ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["yearly"]!)),
                                                               "monthly" : ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["monthly"]!)),
                                                               "daily" : ShowDailyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["daily"]!)),
                                                               "all" : ShowAllEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["all"]!))]

        
        let contentView = ExpensesSummaryNavigationView(navigationCoordinator: MainNavigationCoordinator(dataSources:dataSources,
                                                                                                         presenters: presenters, coreDataFetchController: BSCoreDataFetchController(coreDataController: coreDataController), selectedCategoryDataSource: selectedCategoryDataSource))
        
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

