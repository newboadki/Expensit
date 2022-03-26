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
        return ["yearly" : ShowYearlyEntriesPresenter(interactor: YearlyExpensesSummaryInteractor(dataSource: dataSources["yearly"]!), subscriptionScheduler: DispatchQueue.global(), receiveOnScheduler: RunLoop.main),
                "monthly" : ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["monthly"]!), subscriptionScheduler: DispatchQueue.global(), receiveOnScheduler: RunLoop.main),
                "daily" : ShowDailyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["daily"]!), subscriptionScheduler: DispatchQueue.global(), receiveOnScheduler: RunLoop.main),
                "all" : ShowAllEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: dataSources["all"]!), subscriptionScheduler: DispatchQueue.global(), receiveOnScheduler: RunLoop.main)]
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
                                              saveExpense: EditExpenseInteractor(dataSource: individualEntriesDataSource),
                                              defaultRates: DefaultRatesInteractor(),
                                              currenciesDataSource: CurrenciesCoreDataDataSource(context: context))
    }
    
    func currencyCodeChangeManager() -> CurrencyCodeChangeInteractor {
        return CurrencyCodeChangeInteractor(exchangeRatesConversionInteractor: exchangeRatesConversionInteractor(),
                                         allEntriesDataSource: dataSources["all"]! as! AllEntriesCoreDataExpensesDataSource,
                                         currencySettingsInteractor: CurrencySettingsDefaultInteractor(dataSoure: CurrencySettingsDefaultDataSource()))
    }    
}
