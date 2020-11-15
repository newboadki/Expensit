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
import Currencies

let kPreviousLocaleCurrencyCode = "previous-currrent-locale"

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var workerQueue = DispatchQueue(label: "ExpensesSummaryInteractor")
    private var di = DependencyInjection()

    var cds = CurrencyExchangeRatesNetworkDataSource()
    var migrateRates: ConvertToBaseCurrencyInteractor?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        DispatchQueue.global().async {
            
            // Database Migrations
            self.di.coreDataModelMigrationInteractor().applyPendingMigrations(to: self.di.coreDataModel)
            
            // Convert exchange rates
            self.converExchangeRatesIfCalculationsAreApproximated()

            // Setup the view
            let contentView = ExpensesSummaryNavigationView(navigationCoordinator: self.di.mainNavigationCoordinator())
            
            DispatchQueue.main.async {
                // Use a UIHostingController as window root view controller.
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = UIHostingController(rootView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }        
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
        converExchangeRatesIfCurrencyChanged()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        UserDefaults.standard.setValue(Locale.current.currencyCode, forKey: kPreviousLocaleCurrencyCode)
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
    
    private func converExchangeRatesIfCurrencyChanged() {
        let previousCode = UserDefaults.standard.value(forKey: kPreviousLocaleCurrencyCode)
        let currentCode = Locale.current.currencyCode

        if let p = previousCode as? String,
           let c = currentCode,
           (p != c) {
            self.di.exchangeRatesConversionInteractor().convertAllEntries(from: p, to: c)
            let all = self.di.dataSources["all"] as! AllEntriesCoreDataExpensesDataSource
            let ratesAreApproximated = all.isExchangeRateToBaseApproximated()
            if !ratesAreApproximated {
                UserDefaults.standard.setValue(currentCode, forKey: kPreviousLocaleCurrencyCode)
            }
        }
    }
    
    private func converExchangeRatesIfCalculationsAreApproximated() {
        let all = self.di.dataSources["all"] as! AllEntriesCoreDataExpensesDataSource
        let ratesAreApproximated = all.isExchangeRateToBaseApproximated()
        if ratesAreApproximated {
            let previousCode = UserDefaults.standard.value(forKey: kPreviousLocaleCurrencyCode) as! String
            let currentCode = Locale.current.currencyCode!
            self.di.exchangeRatesConversionInteractor().convertAllEntries(from: previousCode, to: currentCode)
            let approximated = all.isExchangeRateToBaseApproximated()
            if !approximated {
                UserDefaults.standard.setValue(currentCode, forKey: kPreviousLocaleCurrencyCode)
            }
        }
    }
}
