//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 21.05.2021..
//

import XCTest
import Foundation
import DateAndTime
@testable import CoreExpenses

struct ConvertToBaseCurrencyInteractorProvider {
    
    typealias TestComponents = (convertInteractor: ConvertToBaseCurrencyInteractor, invididualEntries: IndividualEntryDataSourceMock, entriesInDb: EntriesSummaryDataSource)
    
    static func entriesDataSourceMock(withEntries mockEntries: [Expense], approximated: Bool) -> EntriesSummaryDataSourceMock {
        let g1 = ExpensesGroup(groupKey: DateComponents(year:2021), entries: mockEntries)
        return EntriesSummaryDataSourceMock(groups: [g1], isExchangeRateToBaseApproximated: approximated)
    }

    static func testComponents(from testInfo: ConvertToBaseInteractorTestInfo, approximated: Bool) -> TestComponents {
        let entriesDataSource = entriesDataSourceMock(withEntries: testInfo.expensesInDataBase, approximated: approximated)
        let rateDataSourceMock = CurrencyExchangeRatesDataSourceMock(exchangeInfo: testInfo.exchangeInfo, rates: testInfo.rates, error: testInfo.exchangeInfoError)
        let saveDataSourceMock = IndividualEntryDataSourceMock()
        let saveDataInteractorMock = EditExpenseInteractor(dataSource: saveDataSourceMock)
        let interactor = ConvertToBaseCurrencyInteractor(dataSource: entriesDataSource, ratesDataSource: rateDataSourceMock, saveExpense: saveDataInteractorMock, defaultRates: DefaultRatesInteractor(), currenciesDataSource: CurrenciesDataSourceMock(existingCurrencyCodes: testInfo.existingCurrencyCodes))
        return (convertInteractor: interactor, invididualEntries: saveDataSourceMock, entriesInDb:entriesDataSource)
    }
    
    static func emptyExchangeInfo(from startDate: String, to endDate: String, baseCurrency: String) -> CurrencyExchangeInfo {
        return CurrencyExchangeInfo(rates: [String : [String : NSDecimalNumber]](),
                                    start_at: DateConversion.date(withFormat:DateFormats.reversedHyphenSeparated, from: startDate),
                                    end_at: DateConversion.date(withFormat: DateFormats.reversedHyphenSeparated, from: endDate),
                                    base: baseCurrency)
    }
    
    static func exchangeInfo(from exchangeDictionary: [String : [String : NSDecimalNumber]], startDate: String, endDate: String, baseCurrency: String) -> CurrencyExchangeInfo {
        return CurrencyExchangeInfo(rates: exchangeDictionary,
                                    start_at: DateConversion.date(withFormat:DateFormats.reversedHyphenSeparated, from: startDate),
                                    end_at: DateConversion.date(withFormat: DateFormats.reversedHyphenSeparated, from: endDate),
                                    base: baseCurrency)

    }

    static func emptyRates() -> CurrencyConversionRates {
        CurrencyConversionRates(rates: [:], date: Date(), base: "", isApproximation: true)
    }

    static func entryInBaseCurrency(_ desc: String, _ dateComponents: DateComponents, _ value: NSDecimalNumber, _ code: String) -> Expense {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents)!
        return Expense(dateComponents: dateComponents,
                       date: date,
                       value: value,
                       valueInBaseCurrency: value,
                       description: desc,
                       category: ExpenseCategory(name: "Work", iconName: "", color: .black),
                       currencyCode: code,
                       exchangeRateToBaseCurrency: 1,
                       isExchangeRateUpToDate: true)
        
    }

    static func entryInOtherCurrency(_ desc: String, _ dateComponents: DateComponents, _ value: NSDecimalNumber, _ code: String) -> Expense {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents)!
        return Expense(dateComponents: dateComponents,
                       date: date,
                       value: value,
                       valueInBaseCurrency: value,
                       description: desc,
                       category: ExpenseCategory(name: "Bills", iconName: "", color: .black),
                       currencyCode: code,
                       exchangeRateToBaseCurrency: 1.56,
                       isExchangeRateUpToDate: false)
        
    }
    
    static func assertEntryInDB(_ expenseId: String, _ currencyCode: String, _ exchangeToBase: NSDecimalNumber, _ isExchangeRateUpToDate: Bool, valueInBaseCurrency: NSDecimalNumber, _ testComponents: ConvertToBaseCurrencyInteractorProvider.TestComponents) {
        guard let e = testComponents.invididualEntries.expensesRequestedToSave!.filter({ el in el.entryDescription == expenseId }).first else {
            XCTFail("Expense \(expenseId) not found")
            return
        }
        
        XCTAssert(e.exchangeRateToBaseCurrency == exchangeToBase)
        XCTAssert(e.isExchangeRateUpToDate == isExchangeRateUpToDate)
        XCTAssert(e.valueInBaseCurrency == valueInBaseCurrency)
        XCTAssert(e.currencyCode == currencyCode)
    }
    
    static func testInfoWithEmptyExchangeInfo(_ startDate: String, _ endDate: String, baseCurrency: String, existingCurrencyCodes:[String], entriesInDb: [Expense]) -> ConvertToBaseInteractorTestInfo{
        ConvertToBaseInteractorTestInfo(startDate: startDate,
                                        endDate: endDate,
                                        exchangeInfoError: nil,
                                        exchangeInfo: Self.emptyExchangeInfo(from: startDate, to: endDate, baseCurrency: baseCurrency),
                                        rates: emptyRates(),
                                        base: baseCurrency,
                                        expensesInDataBase: entriesInDb,
                                        existingCurrencyCodes: existingCurrencyCodes)
    }

    static func testInfoWithExchangeInfo(_ mockNetworkRates: [String : [String : NSDecimalNumber]], _ startDate: String, _ endDate: String, baseCurrency: String, existingCurrencyCodes:[String], entriesInDb: [Expense]) -> ConvertToBaseInteractorTestInfo{
        ConvertToBaseInteractorTestInfo(startDate: startDate,
                                        endDate: endDate,
                                        exchangeInfoError: nil,
                                        exchangeInfo: Self.exchangeInfo(from: mockNetworkRates,
                                                                        startDate: startDate,
                                                                        endDate: endDate,
                                                                        baseCurrency: baseCurrency),
                                        rates: emptyRates(),
                                        base: baseCurrency,
                                        expensesInDataBase: entriesInDb,
                                        existingCurrencyCodes: existingCurrencyCodes)
    }

    static func testInfoWithExchangeInfoError(_ startDate: String, _ endDate: String, baseCurrency: String, existingCurrencyCodes:[String], entriesInDb: [Expense]) -> ConvertToBaseInteractorTestInfo{
        ConvertToBaseInteractorTestInfo(startDate: startDate,
                                        endDate: endDate,
                                        exchangeInfoError: CurrencyExchangeRatesDataSourceMock.GenericError(),
                                        exchangeInfo: Self.emptyExchangeInfo(from: startDate, to: endDate, baseCurrency: baseCurrency),
                                        rates: emptyRates(),
                                        base: baseCurrency,
                                        expensesInDataBase: entriesInDb,
                                        existingCurrencyCodes: existingCurrencyCodes)
    }
    
    
}

