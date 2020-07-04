//
//  BSAddEntryController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSAddEntryController: NSObject, BSAddEntryControllerProtocol {
    
    var coreDataFetchController : BSCoreDataFetchController
    
    @objc init(coreDataFetchController: BSCoreDataFetchController)
    {        
        self.coreDataFetchController = coreDataFetchController
        super.init()
    }

    /// BSAddEntryControllerProtocol
    
    func save(entry : Expense, successBlock :()->(), failureBlock:(_ error : NSError) -> () )
    {
        if NSDecimalNumber(string: "0").compare(entry.value) == .orderedSame
        {
            failureBlock(NSError(domain: "Could not save!!", code: 1, userInfo: nil))
            return
        }
        let (success, error) = self.coreDataFetchController.save(existingEntry: entry)
        if success {
            successBlock()
        } else {
            if let err = error {
                failureBlock(err)
            } else {
                failureBlock(NSError(domain: "Could not save!!", code: 1, userInfo: nil))
            }
        }                
    }
    
    func delete(entry : Expense) {
        self.coreDataFetchController.delete(entry: entry)
        self.coreDataFetchController.saveChanges()
    }
}
