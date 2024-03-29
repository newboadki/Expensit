//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 26.04.2021..
//

import XCTest
@testable import CoreExpenses
import Foundation
import DateAndTime

class ConvertToBaseCurrencyInteractorTests: XCTestCase {
    
    private typealias Provider = ConvertToBaseCurrencyInteractorProvider
    private let mockNetworkRates: [String : [String : NSDecimalNumber]] = ["2021-01-01" : ["GBP" : 1.160,
                                                                                           "USD" : 0.89],
                                                                           "2021-01-02" : ["GBP" : 1.161,
                                                                                           "USD" : 0.90]]
    
    private let mockNetworkRates_20210101: [String : [String : NSDecimalNumber]] = ["2021-01-01" : ["GBP" : 1.160,
                                                                                                    "USD" : 0.89]]
    func testNothingGetsUpdatedIfTheresNoRateInfo() async throws {
        let testInfo = Provider.testInfoWithEmptyExchangeInfo("2021-01-01",
                                                              "2021-01-07",
                                                              baseCurrency: "EUR",
                                                              existingCurrencyCodes: ["USD"],
                                                              entriesInDb: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 1), 15_000, "USD"),
                                                                            Provider.entryInBaseCurrency("e2", DateComponents(year: 2021, month: 1, day: 2), 1_000, "USD")])
        
        let testComponents = ConvertToBaseCurrencyInteractorProvider.testComponents(from: testInfo, approximated: false)
        await testComponents.0.convertAllEntries(to: "EUR")
        
        // Expectations
        Provider.assertEntryInDB("e1", "USD", 1, true, valueInBaseCurrency: 15_000, testComponents)
        Provider.assertEntryInDB("e2", "USD", 1, true, valueInBaseCurrency: 1_000, testComponents)
    }
    
    func testEntriesAreUpdatedWhenDataContainsRatesForTheEntriesDates() async {
        let testInfo = Provider.testInfoWithExchangeInfo(mockNetworkRates, "2021-01-01", "2021-01-07", baseCurrency: "EUR", existingCurrencyCodes: ["USD"],
                                                         entriesInDb: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 1), 15000, "USD"),
                                                                       Provider.entryInBaseCurrency("e2", DateComponents(year: 2021, month: 1, day: 2), 1000, "USD")])
        
        let testComponents = ConvertToBaseCurrencyInteractorProvider.testComponents(from: testInfo, approximated: false)
        await testComponents.0.convertAllEntries(to: "EUR")
                
        // Expectations
        Provider.assertEntryInDB("e1", "USD", 0.89, true, valueInBaseCurrency: 13_350, testComponents)
        Provider.assertEntryInDB("e2", "USD", 0.90, true, valueInBaseCurrency: 900, testComponents)
    }
    
    func testEntriesAreUpdatedWhenDataContainsRatesForTheDayBeforeOfTheRequestedDate() async {
        let testInfo = Provider.testInfoWithExchangeInfo(mockNetworkRates_20210101, "2021-01-01", "2021-01-07", baseCurrency: "EUR", existingCurrencyCodes: ["EUR", "USD"],
                                                         entriesInDb: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 2), 1000, "USD")])

        let testComponents = ConvertToBaseCurrencyInteractorProvider.testComponents(from: testInfo, approximated: false)
        await testComponents.0.convertAllEntries(to: "EUR")

        // Expectations
        Provider.assertEntryInDB("e1", "USD", 0.89, true, valueInBaseCurrency: 890, testComponents)
    }

    func testEntriesAreUpdatedWhenDataContainsRatesForTheDayAfterOfTheRequestedDate() async {
        let mockRates: [String : [String : NSDecimalNumber]] = ["2021-01-02" : ["GBP" : 1.161,
                                                                                "USD" : 0.90]]

        let testInfo = Provider.testInfoWithExchangeInfo(mockRates, "2021-01-01", "2021-01-07", baseCurrency: "EUR",
                                                         existingCurrencyCodes: ["USD"],
                                                         entriesInDb: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 1), 1000, "USD")])

        let testComponents = ConvertToBaseCurrencyInteractorProvider.testComponents(from: testInfo, approximated: false)
        await testComponents.0.convertAllEntries(to: "EUR")

        // Expectations
        Provider.assertEntryInDB("e1", "USD", 0.90, true, valueInBaseCurrency: 900, testComponents)
    }
    
    func testEntriesAreNotModifiedIfDatesAreNotPresent() async {
        let mockRates: [String : [String : NSDecimalNumber]] = ["2021-01-02" : ["GBP" : 1.161,
                                                                                "USD" : 0.90]]

        let testInfo = Provider.testInfoWithExchangeInfo(mockRates, "2021-01-01", "2021-01-07", baseCurrency: "EUR",
                                                         existingCurrencyCodes: ["GBP", "USD"],
                                                         entriesInDb: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 5, day: 25), 1000, "USD"),
                                                                       Provider.entryInOtherCurrency("e2", DateComponents(year: 2021, month: 5, day: 25), 480, "GBP")])

        let testComponents = ConvertToBaseCurrencyInteractorProvider.testComponents(from: testInfo, approximated: false)
        await testComponents.0.convertAllEntries(to: "EUR")

        // Expectations
        Provider.assertEntryInDB("e1", "USD", 1, true, valueInBaseCurrency: 1000, testComponents)
        Provider.assertEntryInDB("e2", "GBP", 1.56, false, valueInBaseCurrency: 480, testComponents)
    }
    
    func testEntriesUpdatedWithDefaultRatesIfDataSourceFailsToRetrieveRates() async {
        let testInfo = Provider.testInfoWithExchangeInfoError("2021-01-01", "2021-01-07", baseCurrency: "EUR",
                                                              existingCurrencyCodes: ["EUR", "GBP", "USD"],
                                                entriesInDb: [Provider.entryInOtherCurrency("e1", DateComponents(year: 2021, month: 5, day: 25), 1000, "USD"),
                                                             Provider.entryInOtherCurrency("e2", DateComponents(year: 2021, month: 5, day: 25), 480, "GBP"),
                                                             Provider.entryInBaseCurrency("e3", DateComponents(year: 2021, month: 5, day: 25), 5_000, "EUR")])
        
        let testComponents = ConvertToBaseCurrencyInteractorProvider.testComponents(from: testInfo, approximated: false)
        await testComponents.0.convertAllEntries(to: "EUR")
        
        // Expectations
        Provider.assertEntryInDB("e1", "USD", 0.86, false, valueInBaseCurrency: 860, testComponents)
        Provider.assertEntryInDB("e2", "GBP", 1.10, false, valueInBaseCurrency: 528, testComponents)
        Provider.assertEntryInDB("e3", "EUR", 1, true, valueInBaseCurrency: 5_000, testComponents)
    }
}

struct ConvertToBaseInteractorTestInfo {
    let startDate: String
    let endDate: String
    let exchangeInfoError: Error?
    let exchangeInfo: CurrencyExchangeInfo
    let rates: CurrencyConversionRates
    let base: String
    let expensesInDataBase: [Expense]
    let existingCurrencyCodes: [String]
}
