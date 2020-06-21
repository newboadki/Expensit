//
//  YearlySummaryTests.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 29/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import XCTest

class YearlySummaryTests: XCTestCase {
    
    private var presenter: ShowYearlyEntriesPresenter!
    
    override func setUp() {
        var tg = TestDataGenerator()
        tg.generate()
                
        let yearlySummaryDataSource = YearlyCoreDataExpensesDataSource(coreDataController:tg.coreDataController,
                                                                       selectedCategoryDataSource: SelectedCategoryDataSource())
        presenter = ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: yearlySummaryDataSource))
    }

    override func tearDown() {
        
    }

    func testExample() {
        XCTAssert(presenter.sections.count == 1, "There should be one section.")
        XCTAssert(presenter.sections.first!.entries.count == 3, "There should be x years.")
    }

    

}
