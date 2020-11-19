//
//  DependencyInjection.swift
//  Expensit
//
//  Created by Borja Arias Drake on 08/11/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreDataPersistence
import CoreExpenses
import Currencies
import DateAndTime

class DependencyInjection {
    
    var context: NSManagedObjectContext!
    private static let semaphore = DispatchSemaphore(value: 1)
    
    init() {
        // Initialize CoreData's Stack
        CoreDataStack.context { result in
            switch result {
                case .failure(let coreDataError):
                    print(coreDataError)
                case .success(let context):
                    self.context = context
            }
            Self.semaphore.signal()
        }
        Self.semaphore.wait()
    }
    
    var coreDataModel: NSManagedObjectModel {
        CoreDataStack.model()
    }
    
    lazy var selectedCategoryDataSource: CoreDataCategoryDataSource = {
        return CoreDataCategoryDataSource(context: self.context)
    }()

    lazy var individualEntriesDataSource: IndividualExpensesDataSource = {
        return IndividualExpensesDataSource(context:self.context)
    }()
    
    lazy var dataSources: [String: EntriesSummaryDataSource] = {
        return ["yearly" : YearlyCoreDataExpensesDataSource(coreDataContext:self.context, selectedCategoryDataSource: selectedCategoryDataSource),
                "monthly" : MonthlyCoreDataExpensesDataSource(coreDataContext:self.context, selectedCategoryDataSource: selectedCategoryDataSource),
                "daily" : DailyCoreDataExpensesDataSource(coreDataContext:self.context, selectedCategoryDataSource: selectedCategoryDataSource),
                "all" : AllEntriesCoreDataExpensesDataSource(coreDataContext:self.context, selectedCategoryDataSource: selectedCategoryDataSource)]
    }()
    
    lazy var presenters: [String: AbstractEntriesSummaryPresenter] = {
        return ["yearly" : ShowYearlyEntriesPresenter(interactor: YearlyExpensesSummaryInteractor(dataSource: dataSources["yearly"]!)),
                "monthly" : ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["monthly"]!)),
                "daily" : ShowDailyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["daily"]!)),
                "all" : ShowAllEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["all"]!))]
    }()
    
    func mainNavigationCoordinator() -> MainNavigationCoordinator {
        let navigationButtonsPresenter = NavigationButtonsPresenter(selectedCategoryInteractor: SelectedCategoryInteractor(dataSource: selectedCategoryDataSource))
        return MainNavigationCoordinator(dataSources:dataSources,
                                         presenters: presenters,
                                         navigationButtonsPresenter: navigationButtonsPresenter,
                                         coreDataContext: self.context,
                                         selectedCategoryDataSource: selectedCategoryDataSource)
    }
    
    func coreDataModelMigrationInteractor() -> CoreDataModelMigrationsInteractor {
        return CoreDataModelMigrationsInteractor(categoryDataSource: selectedCategoryDataSource,
                                                 individualEntriesDataSource: individualEntriesDataSource,
                                                 currencySettingsInteractor: CurrencySettingsDefaultInteractor(dataSoure: CurrencySettingsDefaultDataSource()))
    }
    
    func exchangeRatesConversionInteractor() -> ConvertToBaseCurrencyInteractor {
        return ConvertToBaseCurrencyInteractor(dataSource: dataSources["all"]!,
                                              ratesDataSource: CurrencyExchangeRatesDataSourceMapper(dataSource: CurrencyExchangeRatesNetworkDataSource()),
                                              saveExpense: EditExpenseInteractor(dataSource: individualEntriesDataSource))
    }
    
    func currencyCodeChangeManager() -> CurrencyCodeChangeInteractor {
        return CurrencyCodeChangeInteractor(exchangeRatesConversionInteractor: exchangeRatesConversionInteractor(),
                                         allEntriesDataSource: dataSources["all"]! as! AllEntriesCoreDataExpensesDataSource,
                                         currencySettingsInteractor: CurrencySettingsDefaultInteractor(dataSoure: CurrencySettingsDefaultDataSource()))
    }
    
    private func populate() {
        let expensesDS = individualEntriesDataSource
        let categoriesDS = selectedCategoryDataSource
        let d1 = DateConversion.date(withFormat: DateFormats.defaultFormat, from: "07/07/2020")
        let dc1 = DateComponents(year: d1.component(.year), month: d1.component(.month), day: d1.component(.day), hour: d1.component(.hour), minute: d1.component(.minute), second: d1.component(.second))
        _ = expensesDS.add(expense: Expense(dateComponents: dc1,
                                            date: d1,
                                            value: 500,
                                            valueInBaseCurrency: 500,
                                            description: "Gift",
                                            category: categoriesDS.category(for: "Income"),
                                            currencyCode: "GBP",
                                            exchangeRateToBaseCurrency: 1,
                                            isExchangeRateUpToDate: false))

        let d2 = DateConversion.date(withFormat: DateFormats.defaultFormat, from: "01/01/2019")
        let dc2 = DateComponents(year: d2.component(.year), month: d2.component(.month), day: d2.component(.day), hour: d2.component(.hour), minute: d2.component(.minute), second: d2.component(.second))
        _ = expensesDS.add(expense: Expense(dateComponents: dc2,
                                            date: d2,
                                            value: 15000,
                                            valueInBaseCurrency: 15000,
                                            description: "Gift",
                                            category: categoriesDS.category(for: "Income"),
                                            currencyCode: "GBP",
                                            exchangeRateToBaseCurrency: 1,
                                            isExchangeRateUpToDate: true))

        let d3 = DateConversion.date(withFormat: DateFormats.defaultFormat, from: "01/01/2016")
        let dc3 = DateComponents(year: d3.component(.year), month: d3.component(.month), day: d3.component(.day), hour: d3.component(.hour), minute: d3.component(.minute), second: d3.component(.second))
        _ = expensesDS.add(expense: Expense(dateComponents: dc3,
                                            date: d3,
                                            value: 3000,
                                            valueInBaseCurrency: 3000,
                                            description: "Gift",
                                            category: categoriesDS.category(for: "Income"),
                                            currencyCode: "GBP",
                                            exchangeRateToBaseCurrency: 1,
                                            isExchangeRateUpToDate: true))
    }
}
