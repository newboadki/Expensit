//
//  swift
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
    
    private var presenter: ShowYearlyEntriesPresenter<ImmediateScheduler, ImmediateScheduler>!
    private var selectedCategoryDataSource: CategoryDataSource!
    private var setCategoryInteractor: SetCategoryFilterInteractor!
    private var context: NSManagedObjectContext!
    private var cancellable: AnyCancellable?
    
    func setupDependencies() async throws {
        let tg = TestDataGenerator()
        context = try await tg.generate()
        selectedCategoryDataSource = CoreDataCategoryDataSource(context: context)
        setCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource)
        let yearlySummaryDataSource = YearlyCoreDataExpensesDataSource(coreDataContext:tg.coreDataContext,
                                                                       selectedCategoryDataSource: selectedCategoryDataSource)
        self.presenter = ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource:yearlySummaryDataSource),
                                                    subscriptionScheduler: ImmediateScheduler.shared,
                                                    receiveOnScheduler: ImmediateScheduler.shared)
        cancellable?.cancel()
        cancellable = nil
        presenter.bind()

    }
    
    override func tearDown() {
        cancellable?.cancel()
        cancellable = nil
        presenter.unbind()
    }
}

// MARK: - Category Filter tests
extension YearlySummaryTests {
    
    func test_yearly_breakdown_all_categories() async throws {
        try await setupDependencies()
        Test.assertSectionsEventually([Test.Expense(title: "2015", value: "-$163.20"),
                                       Test.Expense(title: "2014", value: "$8,437.70"),
                                       Test.Expense(title: "2013", value: "$5,034.10")],
                                      inSection: 0,
                                      sectionCount: 1,
                                      cancellable: &cancellable,
                                      presenter: presenter,
                                      testCase: self)
    }
    
    func test_yearly_breakdown_food() async throws {
        try await setupDependencies()
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Food", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "2014", value: "-$161.40"),
                                       Test.Expense(title: "2013", value: "-$60.00")],
                                      inSection: 0,
                                      sectionCount: 1,
                                      cancellable: &cancellable,
                                      presenter: presenter,
                                      testCase: self)
    }
    
    func test_yearly_breakdown_bills() async throws {
        try await setupDependencies()
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Bills", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "2014", value: "-$180.00"),
                                       Test.Expense(title: "2013", value: "-$45.00")],
                                      inSection: 0,
                                      sectionCount: 1,
                                      cancellable: &cancellable,
                                      presenter: presenter,
                                      testCase: self)
    }
    
    func test_yearly_breakdown_travel() async throws {
        try await setupDependencies()
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Travel", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "2015", value: "-$163.20"),
                                       Test.Expense(title: "2014", value: "$3,779.10"),
                                       Test.Expense(title: "2013", value: "-$320.90")],
                                      inSection: 0,
                                      sectionCount: 1,
                                      cancellable: &cancellable,
                                      presenter: presenter,
                                      testCase: self)
    }

    func test_yearly_breakdown_incoming() async throws {
        try await setupDependencies()
        setCategoryInteractor.filter(by: ExpenseCategory(name: "Income", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "2014", value: "$5,000.00"),
                                        Test.Expense(title: "2013", value: "$5,550.00")],
                                      inSection: 0,
                                      sectionCount: 1,
                                      cancellable: &cancellable,
                                      presenter: presenter,
                                      testCase: self)
    }
}
