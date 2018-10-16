//
//  ShowMonthlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 20/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit



/// Contains template code to be adapted by concrete implementations of presenters.
class BSAbstractShowEntriesPresenter : NSObject, BSAbstractExpensesSummaryPresenterEventsProtocol {
    
    var showEntriesController : BSAbstractShowEntriesControllerProtocol
    var userInteface : BSAbstractExpensesSummaryUserInterfaceProtocol
    var backgroundQueue: DispatchQueue
    
    
    init!(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
         showEntriesController : BSAbstractShowEntriesControllerProtocol) {
        self.userInteface = showEntriesUserInterface
        self.showEntriesController = showEntriesController
        self.backgroundQueue = DispatchQueue(label: "com.expensit.presenter.background.queue")
        super.init()
    }
    
    
    // MARK: BSBaseExpensesSummaryPresenterEventsProtocol
    
    func filterChanged(to category : ExpenseCategory?) {
        self.showEntriesController.filter(by : category)
    }
    
    
    func viewIsReadyToDisplayEntriesCompletionBlock(_ block: @escaping ( _ sections : [BSDisplayExpensesSummarySection] ) -> () )
    {
        // Let controller subclasses retrieve the right type of information
        self.backgroundQueue.async {
            let groupedEntities = self.showEntriesController.entriesForSummary()
            
            // Let presenter subclasses arrange the data for the user-interface
            let output = self.displayDataFromEntriesForSummary(groupedEntities)
            
            // CallBack once we have the data ready
            DispatchQueue.main.async {
                block( output)
            }
        }
    }
    
    
    func viewIsReadyToDisplayImage(for category : ExpenseCategory?) {
                
        if let image = self.showEntriesController.image(for: category) {
            self.userInteface.displayCategoryImage(image)
        }
    }
    
    
    func filterButtonTapped() {
        
    }
    
    
    func addNewEntryButtonTapped() {
        
    }
    
    
    func displayDataFromEntriesForSummary(_ sections : [ExpensesGroup]) -> [BSDisplayExpensesSummarySection]
    {
        return []
    }
    
}
