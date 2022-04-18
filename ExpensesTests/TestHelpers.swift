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
    
    struct SectionInfo {
        let expectedEntries: [Test.Expense]
        let sectionIndex: Int
        let sectionName: String
    }
    
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
    
    static func assertEqualEntries(_ expectedEntries: [Test.Expense], inSection sectionIndex: Int, named sectionName: String = "", sections: [ExpensesSummarySectionViewModel]) {
        let section = sections[sectionIndex]
        let expectedEntriesCount = expectedEntries.count
        XCTAssert(section.title == sectionName)
        XCTAssert(section.entries.count == expectedEntriesCount, "There should be \(expectedEntriesCount) years in the summary.")
        
        for (index, expectedEntry) in expectedEntries.enumerated() {
            let entry = section.entries[index]
            Test.assertEqual(expectedEntry, title: entry.title!, value: entry.value!)
        }
    }

    static func assertEqualEntries(_ expectedSection: SectionInfo, inSection section: ExpensesSummarySectionViewModel) {
        XCTAssert(section.title == expectedSection.sectionName)
        XCTAssert(section.entries.count == expectedSection.expectedEntries.count, "There should be XXX in the summary.")
        
        for (index, expectedEntry) in expectedSection.expectedEntries.enumerated() {
            let entry = section.entries[index]
            Test.assertEqual(expectedEntry, title: entry.title!, value: entry.value!)
        }
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

    static func assertTheresOnlyOneSection(sections: [ExpensesSummarySectionViewModel]) throws -> ExpensesSummarySectionViewModel {
        XCTAssert(sections.count == 1, "There should be one section.")
        guard let onlySection = sections.first else {
            throw BaseError()
        }
        return onlySection
    }

    static func assertSectionsEventually(_ sectionsInfo: [SectionInfo], cancellable: inout AnyCancellable?, presenter: AbstractTestPresenter, testCase: XCTestCase, checkAfterUpdateCount: Int = 2) {
        let expectation = XCTestExpectation(description: "Sections should have been updated")
        var updateCount = 0
        cancellable = presenter.$sections.sink(receiveValue: { sections in
            
            /*
             * We need this because we are using filters, and that means that before the filter is set, we receive an update and
             * after the filter is set we receive the new set of filtered sections.
             */
            if updateCount == checkAfterUpdateCount {
                XCTAssert(sections.count == sectionsInfo.count)
                
                for i in 0..<sections.count {
                    Test.assertEqualEntries(sectionsInfo[i], inSection: sections[sections.count-1-i])
                }

                expectation.fulfill()
            }
            
            updateCount += 1
        })
        
        testCase.wait(for: [expectation], timeout: 1)
    }

    static func assertSectionsEventually(_ expectedEntries: [Test.Expense], inSection section: Int, sectionName: String = "", sectionCount: Int,  cancellable: inout AnyCancellable?, presenter: AbstractTestPresenter, testCase: XCTestCase, checkAfterUpdateCount: Int = 2) {
        let expectation = XCTestExpectation(description: "Sections should have been updated")
        var updateCount = 0
        cancellable = presenter.$sections.sink(receiveValue: { sections in            
            /*
             * We need this because we are using filters, and that means that before the filter is set, we receive an update and
             * after the filter is set we receive the new set of filtered sections.
             */
            if updateCount == checkAfterUpdateCount {
                XCTAssert(sections.count == sectionCount)

                Test.assertEqualEntries(expectedEntries,
                                        inSection: section,
                                        named: sectionName,
                                        sections: sections)
                expectation.fulfill()

            }
            
            updateCount += 1
        })
        
        testCase.wait(for: [expectation], timeout: 1)
    }
    
}
