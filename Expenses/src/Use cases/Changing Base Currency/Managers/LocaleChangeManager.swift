//
//  LocaleChangeManager.swift
//  Expensit
//
//  Created by Borja Arias Drake on 08/11/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Currencies

class CurrentLocaleManager {
    
    private var migrateRates: ConvertToBaseCurrencyInteractor
    
    // MARK: - Initialization
    
    init(migrateRates: ConvertToBaseCurrencyInteractor) {
        self.migrateRates = migrateRates
        self.observeNotifications()
    }
    
    deinit {
        self.unobserveNotifications()
    }
    
    // MARK: - Change of locale
    
    @objc private func handleCurrentLocaleChanged(_ notification: Notification) {
        self.migrateRates.convertAllEntries(from: "GBP", to: "EUR")
    }
}

private extension CurrentLocaleManager {
    
    func observeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCurrentLocaleChanged),
                                               name: NSLocale.currentLocaleDidChangeNotification,
                                               object: nil)
    }
    
    func unobserveNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSLocale.currentLocaleDidChangeNotification,
                                                  object: nil)
    }

}

