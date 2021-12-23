//
//  CoreDataModelMigrationsInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 12/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreExpenses

public class CoreDataModelMigrationsInteractor {
    
    private let kAppliedFixturesVersionNumbersKey = "appliedFixturesVersionNumbersKey";
    private let categoryDataSource: CoreDataCategoryDataSource
    private let individualEntriesDataSource: IndividualExpensesDataSource
    private var currencySettingsInteractor: CurrencySettingsInteractor
    
    public init(categoryDataSource: CoreDataCategoryDataSource,
                individualEntriesDataSource: IndividualExpensesDataSource,
                currencySettingsInteractor: CurrencySettingsInteractor) {
        self.categoryDataSource = categoryDataSource
        self.individualEntriesDataSource = individualEntriesDataSource
        self.currencySettingsInteractor = currencySettingsInteractor
    }
    
    public func applyPendingMigrations(to model: NSManagedObjectModel) async throws {
        guard let version = model.versionIdentifiers.first,
            let currentVersion = version as? String else {
            return
        }
        let v = NSDecimalNumber(string: currentVersion)
        for i in 0...v.intValue {
            let shouldApplyMigration = addVersionNumberToAppliedFixturesInUserDefaults(i)
            if shouldApplyMigration {                
                try await applyMigration(forVersion: i)
            }
        }
    }
}

private extension CoreDataModelMigrationsInteractor {
    
    func appliedFixturesVersionNumbersFromUserDefaults() -> [Int] {
        guard let appliedVersions = UserDefaults.standard.array(forKey: kAppliedFixturesVersionNumbersKey) as? [Int] else {
            return [Int]()
        }
        return appliedVersions
    }
    
    func addVersionNumberToAppliedFixturesInUserDefaults(_ version: Int) -> Bool {
        var added = false
        var appliedVersionNumbers = appliedFixturesVersionNumbersFromUserDefaults()
        if !appliedVersionNumbers.contains(version) {
            appliedVersionNumbers.append(version)
            UserDefaults.standard.set(appliedVersionNumbers, forKey: kAppliedFixturesVersionNumbersKey)
            added = true
        }
        return added
    }
    
    func applyMigration(forVersion version: Int) async throws {
        switch version {
            case 1:
                try await applyFixtureForModelObjectVersion_1()
            case 2:
                try await applyFixtureForModelObjectVersion_2()
            case 3:
                try await applyFixtureForModelObjectVersion_3()
            case 4:
                try await applyFixtureForModelObjectVersion_4()
            case 5:
                try await applyFixtureForModelObjectVersion_5()

            default:
                break
        }
    }
}

private extension CoreDataModelMigrationsInteractor {
    
    func applyFixtureForModelObjectVersion_1() async throws {

        // 1. Populate tags entry in the data base
        let newCategories = ["Other", "Food", "Bills", "Travel", "Clothing", "Car", "Drinks", "Work", "House", "Gadgets", "Gifts"]
        try await categoryDataSource.create(categories: newCategories, save: false)
        
        // 2. Set a default tag for all existent entries.
        try await categoryDataSource.setToAllEnties("Other", save: false)
        
        // 3. isAmountNegative was added to the Entry model and depends on an existent property value
        try await categoryDataSource.setIsAmountNegative(save: false)

        // 4. Save
        try await categoryDataSource.save()
    }
    
    func applyFixtureForModelObjectVersion_2() async throws {
        // On the version 2 of the model, the tag's imageName was added. Here we populate it
        
        // Add the images for the existing categories
        let other = categoryDataSource.tag(forName: "Other")
        let food = categoryDataSource.tag(forName: "Food")
        let bills = categoryDataSource.tag(forName: "Bills")
        let travel = categoryDataSource.tag(forName: "Travel")
        let clothing = categoryDataSource.tag(forName: "Clothing")
        let car = categoryDataSource.tag(forName: "Car")
        let drinks = categoryDataSource.tag(forName: "Drinks")
        let work = categoryDataSource.tag(forName: "Work")
        let house = categoryDataSource.tag(forName: "House")
        let gadgets = categoryDataSource.tag(forName: "Gadgets")
        let gifts = categoryDataSource.tag(forName: "Gifts")
        
        other.iconImageName = "filter_gifts.png"
        food.iconImageName = "filter_food.png"
        bills.iconImageName = "filter_bills.png"
        travel.iconImageName = "filter_travel.png"
        clothing.iconImageName = "filter_clothing.png"
        car.iconImageName = "filter_car.png"
        drinks.iconImageName = "filter_drinks.png"
        work.iconImageName = "filter_work.png"
        house.iconImageName = "filter_house.png"
        gadgets.iconImageName = "filter_gadgets.png"
        gifts.iconImageName = "filter_gifts.png"
        
        // Create two new categories and set images for them
        try await categoryDataSource.create(categories: ["Music", "Books"], save: false)
        let music = categoryDataSource.tag(forName: "Music")
        let books = categoryDataSource.tag(forName: "Books")
        music.iconImageName = "filter_music.png";
        books.iconImageName = "filter_books.png";
        
        // Save the changes
        try await categoryDataSource.save()
    }

    func applyFixtureForModelObjectVersion_3() async throws {
        // On the version 3
        //   - We added a color property to the entity model
        //   - Also there was a bug that was making tag default to nil if the picker wasn't selected
        
        let other = categoryDataSource.tag(forName: "Other")
        let food = categoryDataSource.tag(forName: "Food")
        let bills = categoryDataSource.tag(forName: "Bills")
        let travel = categoryDataSource.tag(forName: "Travel")
        let clothing = categoryDataSource.tag(forName: "Clothing")
        let car = categoryDataSource.tag(forName: "Car")
        let drinks = categoryDataSource.tag(forName: "Drinks")
        let work = categoryDataSource.tag(forName: "Work")
        let house = categoryDataSource.tag(forName: "House")
        let gadgets = categoryDataSource.tag(forName: "Gadgets")
        let gifts = categoryDataSource.tag(forName: "Gifts")
        let music = categoryDataSource.tag(forName: "Music")
        let books = categoryDataSource.tag(forName: "Books")
                
        other.color = UIColor(red: 87.0/255.0, green: 83.0/255.0, blue: 93.0/255.0, alpha:1)
        food.color = UIColor(red:250.0/255.0, green:178.0/255.0, blue:122.0/255.0, alpha:1.0)
        bills.color = UIColor(red:181.0/255.0, green:34.0/255.0, blue:40.0/255.0, alpha:1.0)
        travel.color = UIColor(red:94.0/255.0, green:184.0/255.0, blue:192.0/255.0, alpha:1.0)
        clothing.color = UIColor(red:104.0/255.0, green:77.0/255.0, blue:148.0/255.0, alpha:1.0)
        car.color = UIColor(red:158.0/255.0, green:50.0/255.0, blue:12.0/255.0, alpha:1.0)
        drinks.color = UIColor(red:253.0/255.0, green:235.0/255.0, blue:1.0/255.0, alpha:1.0)
        work.color = UIColor(red:55.0/255.0, green:72.0/255.0, blue:98.0/255.0, alpha:1.0)
        house.color = UIColor(red:133.0/255.0, green:105.0/255.0, blue:104.0/255.0, alpha:1.0)
        gadgets.color = UIColor(red:236.0/255.0, green:110.0/255.0, blue:69.0/255.0, alpha:1.0)
        gifts.color = UIColor(red:162.0/255.0, green:124.0/255.0, blue:165.0/255.0, alpha:1.0)
        music.color = UIColor(red:232.0/255.0, green:94.0/255.0, blue:120.0/255.0, alpha:1.0)
        books.color = UIColor(red:166.0/255.0, green:120.0/255.0, blue:105.0/255.0, alpha:1.0)
        
        // Set categories without tag to Other Tag
        try await categoryDataSource.setToAllEnties("Other", save: false)
        
        // Create two new categories and set images for them
        try await categoryDataSource.create(categories: ["Income"], save: false)
        let income = categoryDataSource.tag(forName: "Income")
        income.color = UIColor(red:75.0/255.0, green:99.0/255.0, blue:51.0/255.0, alpha:1.0)
        income.iconImageName = "filter_bills.png"

        // Save the changes
        try await categoryDataSource.save()
    }
    
    func applyFixtureForModelObjectVersion_4() async throws {
        try await individualEntriesDataSource.setDateComponentsInAllEntries()
    }

    func applyFixtureForModelObjectVersion_5() async throws {
        let currentCurrencyCode = currencySettingsInteractor.currentCurrencyCode()
        currencySettingsInteractor.setPreviousCurrencyCode(currentCurrencyCode)        
        try await individualEntriesDataSource.setAllEntriesCurrenyCode(to: currentCurrencyCode)
    }
}
