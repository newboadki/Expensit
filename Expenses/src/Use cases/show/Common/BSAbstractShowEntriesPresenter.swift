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
    
    
    init!(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
         showEntriesController : BSAbstractShowEntriesControllerProtocol) {
        self.userInteface = showEntriesUserInterface
        self.showEntriesController = showEntriesController
        super.init()
    }
    
    
    // MARK: BSBaseExpensesSummaryPresenterEventsProtocol
    
    func filterChanged(to category : BSExpenseCategory?) {
        self.showEntriesController.filter(by : category)
    }
    
    
    func viewIsReadyToDisplayEntriesCompletionBlock(_ block: ( _ sections : [BSDisplayExpensesSummarySection] ) -> () )
    {
        // Let controller subclasses retrieve the right type of information
        let groupedEntities = self.showEntriesController.entriesForSummary()
        
        // Let presenter subclasses arrange the data for the user-interface
        let output = self.displayDataFromEntriesForSummary(groupedEntities)
        
        // CallBack once we have the data ready
        block( output)
    }
    
    
    func viewIsReadyToDisplayImage(for category : BSExpenseCategory?) {
                
        if let image = self.showEntriesController.image(for: category) {
            self.userInteface.displayCategoryImage(image)
        }
    }
    
    
    func filterButtonTapped() {
        
    }
    
    
    func addNewEntryButtonTapped() {
        
    }
    
    
    func displayDataFromEntriesForSummary(_ sections : [BSEntryEntityGroup]) -> [BSDisplayExpensesSummarySection]
    {
        return []
    }
    
}
