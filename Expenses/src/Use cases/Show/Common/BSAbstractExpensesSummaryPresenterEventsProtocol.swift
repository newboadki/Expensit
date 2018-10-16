//
//  ShowMonthlyEntriesPresenterProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


/// This protocol decouples the views to display summaries from the business knowledge to organize the information.
/// UI components (normally VC) will communicate events to the presenter through this protocol
@objc protocol BSAbstractExpensesSummaryPresenterEventsProtocol
{
    /// Indicates that the user changed the filter for the system to react
    /// accordanly and prepare new data to display.
    ///
    /// - Parameter category: New category selected in the UI.
    @objc(filterChangedToCategory:)
    func filterChanged(to category : BSExpenseCategory?)
    
    
    /// The UI requests new data to be displayed
    ///
    /// - Parameter _: A completion block that is called asynchronously 
    //    and receives view-models to be presented.
    func viewIsReadyToDisplayEntriesCompletionBlock(_: @escaping ( _ sections : [BSDisplayExpensesSummarySection]) -> ())
    
    
    /// Requests a new image for the category selector UI-control.
    ///
    /// - Parameter category: Category selected in the UI.
    @objc(viewIsReadyToDisplayImageForCategory:)
    func viewIsReadyToDisplayImage(for category : BSExpenseCategory?)
    
    
    /// Notifies the system of an important UI-related event
    func filterButtonTapped()
    
    
    /// Notifies the system of an important UI-related event
    func addNewEntryButtonTapped()    
}
