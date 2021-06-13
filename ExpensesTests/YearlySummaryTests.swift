//
//  YearlySummaryTests.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 29/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import XCTest
import CoreExpenses
import CoreDataPersistence
import CoreData
import Currencies
import Combine

class YearlySummaryTests: XCTestCase {
    
    private static var presenter: ShowYearlyEntriesPresenter<ImmediateScheduler, ImmediateScheduler>!
    private static var selectedCategoryDataSource: CoreDataCategoryDataSource!
    private static var setCategoryInteractor: SetCategoryFilterInteractor!
    private static var context: NSManagedObjectContext!
    
    override static func setUp() {        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let tg = TestDataGenerator()
        context = tg.generate_sync()
        selectedCategoryDataSource = CoreDataCategoryDataSource(context: context)
        setCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource as! CategoryDataSource)
        let yearlySummaryDataSource = YearlyCoreDataExpensesDataSource(coreDataContext:tg.coreDataContext,
                                                                       selectedCategoryDataSource: selectedCategoryDataSource)
        self.presenter = ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource:yearlySummaryDataSource),
                                                    subscriptionScheduler: ImmediateScheduler.shared,
                                                    receiveOnScheduler: ImmediateScheduler.shared)
    }
    
    override func setUp() {
        YearlySummaryTests.presenter.bind()
    }

    override func tearDown() {
        YearlySummaryTests.presenter.unbind()
    }
}

// MARK: - Category Filter tests
extension YearlySummaryTests {
    
    func test_yearly_breakdown_all_categories() throws {
        
        
        try Test.assertTheresOnlyOneSection(presenter: YearlySummaryTests.presenter)
        Test.assertEqualEntries([Test.Expense(title: "2015", value: "-$163.20"),
                                 Test.Expense(title: "2014", value: "$8,437.70"),
                                 Test.Expense(title: "2013", value: "$5,034.10")],
                                inSection: 0,
                                presenter: YearlySummaryTests.presenter)
    }
    
    func test_yearly_breakdown_food() throws {
        YearlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Food", iconName: "", color: .red))
        
        try Test.assertTheresOnlyOneSection(presenter: YearlySummaryTests.presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2014", value: "-$161.40"),
                                 Test.Expense(title: "2013", value: "-$60.00")],
                                inSection: 0,
                                presenter: YearlySummaryTests.presenter)
    }
    
    func test_yearly_breakdown_bills() throws {
        YearlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Bills", iconName: "", color: .red))
        
        try  Test.assertTheresOnlyOneSection(presenter: YearlySummaryTests.presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2014", value: "-$180.00"),
                                 Test.Expense(title: "2013", value: "-$45.00")],
                                inSection: 0,
                                presenter: YearlySummaryTests.presenter)
    }
    
    func test_yearly_breakdown_travel() throws {
        YearlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Travel", iconName: "", color: .red))
        
        try Test.assertTheresOnlyOneSection(presenter: YearlySummaryTests.presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2015", value: "-$163.20"),
                                 Test.Expense(title: "2014", value: "$3,779.10"),
                                 Test.Expense(title: "2013", value: "-$320.90")],
                                inSection: 0,
                                presenter: YearlySummaryTests.presenter)
    }

    func test_yearly_breakdown_incoming() throws {
        YearlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Income", iconName: "", color: .red))
                
        try Test.assertTheresOnlyOneSection(presenter: YearlySummaryTests.presenter)
        
        Test.assertEqualEntries([Test.Expense(title: "2014", value: "$5,000.00"),
                                 Test.Expense(title: "2013", value: "$5,550.00")],
                                inSection: 0,
                                presenter: YearlySummaryTests.presenter)
    }
}
