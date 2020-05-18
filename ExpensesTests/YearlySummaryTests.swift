//
//  YearlySummaryTests.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 29/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import XCTest

class YearlySummaryTests: XCTestCase {
    private var yearlyVC: BSYearlyExpensesSummaryViewController!
    
    override func setUp() {
        TestDataGenerator().generate()
        
        let storyboard = UIStoryboard.init(name: "Storyboard", bundle: nil)
        self.yearlyVC = storyboard.instantiateViewController(identifier: "BSYearlyExpensesSummaryViewController") as! BSYearlyExpensesSummaryViewController

        let coreDataController = TestCoreDataStackHelper.coreDataController()        
        let fetchController = BSCoreDataFetchController(coreDataController: coreDataController)
        let controller = BSShowYearlyEntriesController(dataProvider: fetchController)
        let presenter = BSShowYearlyEntriesPresenter(showEntriesUserInterface: yearlyVC, showEntriesController: controller)
        yearlyVC.showEntriesPresenter = presenter;
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        yearlyVC.showEntriesPresenter?.viewIsReadyToDisplayEntriesCompletionBlock({ section in
            
        })
    }

    

}
