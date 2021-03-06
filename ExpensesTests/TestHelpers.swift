//
//  TestAssertionsHelper.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 21/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import XCTest
import Combine
@testable import CoreExpenses

typealias AbstractTestPresenter = AbstractEntriesSummaryPresenter<ImmediateScheduler, ImmediateScheduler>

struct Test {
    
    struct Expense {
        let title: String
        let value: String        
    }
    
    struct BaseError: Error {
    }
    
    static func assertEqual(_ entry: Test.Expense, title: String, value: String) {
        XCTAssert(entry.title == title, "Yearly summary's title should be \(title).")
        XCTAssert(entry.value == value, "Yearly summary's value should be \(value).")
    }
    
    static func assertEqualEntries(_ expectedEntries: [Test.Expense], inSection sectionIndex: Int, named sectionName: String = "", presenter: AbstractTestPresenter) {
        let section = presenter.sections[sectionIndex]
        let expectedEntriesCount = expectedEntries.count
        XCTAssert(section.title == sectionName)
        XCTAssert(section.entries.count == expectedEntriesCount, "There should be \(expectedEntriesCount) years in the summary.")
        
        for (index, expectedEntry) in expectedEntries.enumerated() {
            let entry = section.entries[index]
            Test.assertEqual(expectedEntry, title: entry.title!, value: entry.value!)
        }
    }
    
    @discardableResult
    static func assertTheresOnlyOneSection(presenter: AbstractTestPresenter) throws -> ExpensesSummarySectionViewModel {
        
        XCTAssert(presenter.sections.count == 1, "There should be one section.")
        guard let onlySection = presenter.sections.first else {
            throw BaseError()
        }
        return onlySection
    }

}
