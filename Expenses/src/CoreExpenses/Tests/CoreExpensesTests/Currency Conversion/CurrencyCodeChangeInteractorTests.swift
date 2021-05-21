//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 20.05.2021..
//

import XCTest
@testable import CoreExpenses
import Foundation

class CurrencyCodeChangeInteractorTests: XCTestCase {
    
    private typealias Provider = ConvertToBaseCurrencyInteractorProvider
        
    func test_when_theres_no_currency_change_no_approximations() {
        let settingsMock = CurrencySettingsInteractorMock(currentCurrencyCode: "USD", previousCurrencyCode: "USD")
        let convertorMock = ConvertToBaseCurrencyInteractorMock()
        let entriesInDbMock = Provider.entriesDataSourceMock(withEntries: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 1), 15_000, "USD"),
                                                                           Provider.entryInBaseCurrency("e2", DateComponents(year: 2021, month: 1, day: 2), 1_000, "USD")],
                                                                           approximated: false)
        let testSubject = CurrencyCodeChangeInteractor(exchangeRatesConversionInteractor: convertorMock,
                                                       allEntriesDataSource: entriesInDbMock,
                                                       currencySettingsInteractor: settingsMock)
        
        // Test
        testSubject.updateCurrencyExchangeRates()
        
        // Conversion attempted
        XCTAssert(convertorMock.convertAllEntriesCalled == false)

        // Test previousCurrencyCode is not set
        XCTAssert(settingsMock.setPreviousCurrencyCodeCalled == false)
    }

    func test_when_theres_no_currency_change_with_approximations() {
        let settingsMock = CurrencySettingsInteractorMock(currentCurrencyCode: "USD", previousCurrencyCode: "USD")
        let convertorMock = ConvertToBaseCurrencyInteractorMock()
        let entriesInDbMock = Provider.entriesDataSourceMock(withEntries: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 1), 15_000, "USD"),
                                                                           Provider.entryInBaseCurrency("e2", DateComponents(year: 2021, month: 1, day: 2), 1_000, "USD")],
                                                                           approximated: true)
        
        let testSubject = CurrencyCodeChangeInteractor(exchangeRatesConversionInteractor: convertorMock,
                                                       allEntriesDataSource: entriesInDbMock,
                                                       currencySettingsInteractor: settingsMock)
        testSubject.updateCurrencyExchangeRates()
        
        // Conversion attempted
        XCTAssert(convertorMock.convertAllEntriesCalled == true)

        // Test previousCurrencyCode is not set
        XCTAssert(settingsMock.setPreviousCurrencyCodeCalled == false)
    }
    
    func test_currency_changed_network_rates_succeeded() {
        let settingsMock = CurrencySettingsInteractorMock(currentCurrencyCode: "USD", previousCurrencyCode: "EUR")
        let convertorMock = ConvertToBaseCurrencyInteractorMock()
        let entriesInDbMock = Provider.entriesDataSourceMock(withEntries: [Provider.entryInBaseCurrency("e1", DateComponents(year: 2021, month: 1, day: 1), 15_000, "EUR"),
                                                                           Provider.entryInBaseCurrency("e2", DateComponents(year: 2021, month: 1, day: 2), 1_000, "EUR")],
                                                                           approximated: true)
        let testSubject = CurrencyCodeChangeInteractor(exchangeRatesConversionInteractor: convertorMock,
                                                       allEntriesDataSource: entriesInDbMock,
                                                       currencySettingsInteractor: settingsMock)
        testSubject.updateCurrencyExchangeRates()
        
        // Conversion attempted
        XCTAssert(convertorMock.convertAllEntriesCalled == true)

        // Test previousCurrencyCode is not set
        XCTAssert(settingsMock.setPreviousCurrencyCodeCalled == true)
    }
}
