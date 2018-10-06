//
//  BSAddEntryPresenterEventsProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAddEntryPresenterEventsProtocol {
    
    @objc(saveEntry:successBlock:failureBlock:)
    func save(entry : BSDisplayExpensesSummaryEntry, successBlock :()->(), failureBlock:(_ error : NSError) -> () )
    
    func userCancelledEditionOfExistingEntry()
    
    func userSelectedNext() // Submit + new one
    
    func userInterfaceReadyToDiplayEntry()
}
