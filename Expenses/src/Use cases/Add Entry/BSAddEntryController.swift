//
//  BSAddEntryController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSAddEntryController: NSObject, BSAddEntryControllerProtocol {
    
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController
    var coreDataFetchController : BSCoreDataFetchController
    var editingEntry : BSDisplayExpensesSummaryEntry?

    
    init(entryToEdit : BSDisplayExpensesSummaryEntry?, coreDataFetchController: BSCoreDataFetchController)
    {
        let delegate = UIApplication.shared.delegate as! BSAppDelegate
        self.editingEntry = entryToEdit
        self.coreDataStackHelper = delegate.coreDataHelper;
        self.coreDataController = BSCoreDataController(entityName : "Entry", coreDataHelper:self.coreDataStackHelper)
        self.coreDataFetchController = coreDataFetchController
        super.init()
    }

    /// BSAddEntryControllerProtocol
    
    func save(entry : BSExpenseEntry, successBlock :()->(), failureBlock:(_ error : NSError) -> () )
    {
        if NSDecimalNumber(string: "0").compare(entry.value) == .orderedDescending ||
            NSDecimalNumber(string: "0").compare(entry.value) == .orderedSame
        {
            failureBlock(NSError(domain: "Could not save", code: 1, userInfo: nil))
        }
        let _ = self.coreDataFetchController.save(existingEntry: entry)
        successBlock()        
    }
    
    func discardChanges() {
        self.coreDataController.discardChanges()
    }
    
    func delete(entry : BSExpenseEntry) {
        self.coreDataFetchController.delete(entry: entry)
    }
    
    func saveChanges() {
        self.coreDataController.saveChanges()
    }
    
    func newEntry() -> BSDisplayExpensesSummaryEntry {
        return BSDisplayExpensesSummaryEntry(title: "", value: "", signOfAmount:.positive, date: Date().description, tag: nil)
    }    
}
