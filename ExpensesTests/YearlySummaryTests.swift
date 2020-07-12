//
//  YearlySummaryTests.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 29/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import XCTest
@testable import CoreExpenses

class YearlySummaryTests: XCTestCase {
    
    private var presenter: ShowYearlyEntriesPresenter!
    private var selectedCategoryDataSource: CoreDataCategoryDataSource!
    private var setCategoryInteractor: SetCategoryFilterInteractor!
    
    override func setUp() {
        var tg = TestDataGenerator()
        tg.generate()
        
        selectedCategoryDataSource = CoreDataCategoryDataSource(context: tg.coreDataContext)
        setCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource)
        let yearlySummaryDataSource = YearlyCoreDataExpensesDataSource(coreDataContext:tg.coreDataContext,
                                                                       selectedCategoryDataSource: selectedCategoryDataSource)
        presenter = ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: yearlySummaryDataSource))
    }

    override func tearDown() {
        
    }
}

// MARK: - Category Filter tests
extension YearlySummaryTests {
    
    func test_yearly_breakdown_all_categories() {
        Test.assertTheresOnlyOneSection(presenter: presenter)
        Test.assertEqualEntries([Test.Expense(title: "2015", value: "-$163.20"),
                                 Test.Expense(title: "2014", value: "$8,437.70"),
                                 Test.Expense(title: "2013", value: "$5,034.10")],
                                inSection: 0,
                                presenter: presenter)
    }
    
    func test_yearly_breakdown_food() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Food", iconName: "", color: .red))
        
        Test.assertTheresOnlyOneSection(presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2014", value: "-$161.40"),
                                 Test.Expense(title: "2013", value: "-$60.00")],
                                inSection: 0,
                                presenter: presenter)
    }
    
    func test_yearly_breakdown_bills() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Bills", iconName: "", color: .red))
        
        Test.assertTheresOnlyOneSection(presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2014", value: "-$180.00"),
                                 Test.Expense(title: "2013", value: "-$45.00")],
                                inSection: 0,
                                presenter: presenter)
    }
    
    func test_yearly_breakdown_travel() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Travel", iconName: "", color: .red))
        
        Test.assertTheresOnlyOneSection(presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2015", value: "-$163.20"),
                                 Test.Expense(title: "2014", value: "$3,779.10"),
                                 Test.Expense(title: "2013", value: "-$320.90")],
                                inSection: 0,
                                presenter: presenter)
    }

    func test_yearly_breakdown_incoming() {
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Income", iconName: "", color: .red))
                
        Test.assertTheresOnlyOneSection(presenter: presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2014", value: "$5,000.00"),
                                 Test.Expense(title: "2013", value: "$5,550.00")],
                                inSection: 0,
                                presenter: presenter)
    }
}
