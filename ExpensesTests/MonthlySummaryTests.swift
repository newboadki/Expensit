//
//  MonthlySummaryTests.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 23/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import XCTest
import CoreExpenses
import CoreDataPersistence
import Combine

class MonthlySummaryTests: XCTestCase {
    
    private static var presenter: ShowMonthlyEntriesPresenter<ImmediateScheduler, ImmediateScheduler>!
    private static var selectedCategoryDataSource: CoreDataCategoryDataSource!
    private static var setCategoryInteractor: SetCategoryFilterInteractor!
    private var cancellable: AnyCancellable?
    
    override static func setUp() {
        let tg = TestDataGenerator()
        let context = tg.generate_sync()

        TestDataGenerator.printAll(context)
        selectedCategoryDataSource = CoreDataCategoryDataSource(context: context)
        setCategoryInteractor = SetCategoryFilterInteractor(dataSource: selectedCategoryDataSource)
        let monthlySummaryDataSource = MonthlyCoreDataExpensesDataSource(coreDataContext:context,
                                                                       selectedCategoryDataSource: selectedCategoryDataSource)
        presenter = ShowMonthlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: monthlySummaryDataSource),
                                                subscriptionScheduler: ImmediateScheduler.shared,
                                                receiveOnScheduler: ImmediateScheduler.shared)
        
    }

    override func setUp() {
        cancellable?.cancel()
        cancellable = nil
        MonthlySummaryTests.presenter.bind()
    }

    override func tearDown() {
        cancellable?.cancel()
        cancellable = nil
        MonthlySummaryTests.presenter.unbind()
    }
    
}

// MARK: - Category Filter tests
extension MonthlySummaryTests {
    
    func test_monthly_breakdown_all_categories() throws {                
        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: "$4,684.10"),
                                       Test.Expense(title: "FEB", value: "-$135.00"),
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
                                      inSection: 2,
                                      sectionName: "2013",
                                      sectionCount: 3,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 2)
        
        cancellable?.cancel()
        cancellable = nil

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      sectionName: "2014",
                                      sectionCount: 3,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)
        cancellable?.cancel()
        cancellable = nil

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      inSection: 0,
                                      sectionName: "2015",
                                      sectionCount: 3,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)
    }
    
    func test_monthly_breakdown_food() throws {
        MonthlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Food", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: "-$45.00"),
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
                                      inSection: 1,
                                      sectionName: "2013",
                                      sectionCount: 2,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 2)

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      inSection: 0,
                                      sectionName: "2014",
                                      sectionCount: 2,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)
    }

    func test_monthly_breakdown_bills() throws {
        MonthlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Bills", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      inSection: 1,
                                      sectionName: "2013",
                                      sectionCount: 2,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 2)

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      inSection: 0,
                                      sectionName: "2014",
                                      sectionCount: 2,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)
    }

    func test_monthly_breakdown_travel() throws {
        MonthlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Travel", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: "-$320.90"),
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
                                      inSection: 2,
                                      sectionName: "2013",
                                      sectionCount: 3,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 2)

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      sectionName: "2014",
                                      sectionCount: 3,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      inSection: 0,
                                      sectionName: "2015",
                                      sectionCount: 3,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)
    }

    func test_monthly_breakdown_incoming() throws {
        MonthlySummaryTests.setCategoryInteractor.filter(by: ExpenseCategory(name: "Income", iconName: "", color: .red))
        
        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: "$5,050.00"),
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
                                      inSection: 1,
                                      sectionName: "2013",
                                      sectionCount: 2,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 2)

        Test.assertSectionsEventually([Test.Expense(title: "JAN", value: ""),
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
                                      inSection: 0,
                                      sectionName: "2014",
                                      sectionCount: 2,
                                      cancellable: &cancellable,
                                      presenter: MonthlySummaryTests.presenter,
                                      testCase: self,
                                      checkAfter: 1)
    }
}
