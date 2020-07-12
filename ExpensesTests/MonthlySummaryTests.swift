//
//  MonthlySummaryTests.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 23/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import XCTest
@testable import CoreExpenses

class MonthlySummaryTests: XCTestCase {
    
    private var presenter: ShowMonthlyEntriesPresenter!
    private var selectedCategoryDataSource: CoreDataCategoryDataSource!
    private var setCategoryInteractor: SetCategoryFilterInteractor!
    
    override func setUp() {
        var tg = TestDataGenerator()
        tg.generate()
        
        selectedCategoryDataSource = CoreDataCategoryDataSource(context: tg.coreDataContext)
        setCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource)
        let monthlySummaryDataSource = MonthlyCoreDataExpensesDataSource(coreDataContext:tg.coreDataContext,
                                                                       selectedCategoryDataSource: selectedCategoryDataSource)
        presenter = ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: monthlySummaryDataSource))
    }

    override func tearDown() {
        
    }
}

// MARK: - Category Filter tests
extension MonthlySummaryTests {
    
    func test_monthly_breakdown_all_categories() {
        
        XCTAssert(presenter.sections.count == 3)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: "$4,684.10"),
                                 Test.Expense(title: "FEB", value: "-$150.00"),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: "$500.00"),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 0,
                                named: "2013",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: "$3,617.70"),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: "$5,000.00"),
                                 Test.Expense(title: "OCT", value: "-$45.00"),
                                 Test.Expense(title: "NOV", value: "-$45.00"),
                                 Test.Expense(title: "DEC", value: "-$90.00")],
                                inSection: 1,
                                named: "2014",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: "-$163.20"),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 2,
                                named: "2015",
                                presenter: presenter)
    }
    
    func test_monthly_breakdown_food() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Food", iconName: "", color: .red))
        
        XCTAssert(presenter.sections.count == 2)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: "-$45.00"),
                                 Test.Expense(title: "FEB", value: "-$15.00"),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 0,
                                named: "2013",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: "-$161.40"),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 1,
                                named: "2014",
                                presenter: presenter)
                
    }

    func test_monthly_breakdown_bills() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Bills", iconName: "", color: .red))
        
        XCTAssert(presenter.sections.count == 2)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: "-$45.00"),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 0,
                                named: "2013",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: "-$45.00"),
                                 Test.Expense(title: "NOV", value: "-$45.00"),
                                 Test.Expense(title: "DEC", value: "-$90.00")],
                                inSection: 1,
                                named: "2014",
                                presenter: presenter)
    }

    func test_monthly_breakdown_travel() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Travel", iconName: "", color: .red))
        
        XCTAssert(presenter.sections.count == 3)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: "-$320.90"),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 0,
                                named: "2013",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: "$3,779.10"),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 1,
                                named: "2014",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: "-$163.20"),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 2,
                                named: "2015",
                                presenter: presenter)
    }

    func test_monthly_breakdown_incoming() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Income", iconName: "", color: .red))
        
        XCTAssert(presenter.sections.count == 2)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: "$5,050.00"),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: ""),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: "$500.00"),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 0,
                                named: "2013",
                                presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "JAN", value: ""),
                                 Test.Expense(title: "FEB", value: ""),
                                 Test.Expense(title: "MAR", value: ""),
                                 Test.Expense(title: "APR", value: ""),
                                 Test.Expense(title: "MAY", value: ""),
                                 Test.Expense(title: "JUN", value: ""),
                                 Test.Expense(title: "JUL", value: ""),
                                 Test.Expense(title: "AUG", value: ""),
                                 Test.Expense(title: "SEP", value: "$5,000.00"),
                                 Test.Expense(title: "OCT", value: ""),
                                 Test.Expense(title: "NOV", value: ""),
                                 Test.Expense(title: "DEC", value: "")],
                                inSection: 1,
                                named: "2014",
                                presenter: presenter)
    }
}
