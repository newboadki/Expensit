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
    var editingEntry : BSDisplayExpensesSummaryEntry?
    
    @objc init(entryToEdit : BSDisplayExpensesSummaryEntry?, coreDataFetchController: BSCoreDataFetchController)
    {
        self.editingEntry = entryToEdit
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
    
    func discardChanges() {
//        self.coreDataController.discardChanges()
    }
    
    func delete(entry : Expense) {
        self.coreDataFetchController.delete(entry: entry)
        self.coreDataFetchController.saveChanges()
    }
    
    func saveChanges() {
//        self.coreDataController.saveChanges()
    }
    
    func newEntry() -> BSDisplayExpensesSummaryEntry {
        return BSDisplayExpensesSummaryEntry(title: "", value: "", signOfAmount:.positive, date: Date().description, tag: nil)
    }    
}
