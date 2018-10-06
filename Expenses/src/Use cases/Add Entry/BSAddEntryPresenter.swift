//
//  BSAddEntryPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSAddEntryPresenter: NSObject, BSAddEntryPresenterEventsProtocol {
 
    var addEntryController : BSAddEntryControllerProtocol
    var userInterface : BSAddEntryInterfaceProtocol
    var indexPathOfEntryToEdit : NSIndexPath?
    var displayEntry: BSDisplayExpensesSummaryEntry?

    init(displayEntry: BSDisplayExpensesSummaryEntry?, addEntryController: BSAddEntryControllerProtocol, userInterface : BSAddEntryInterfaceProtocol, indexPathOfEntryToEdit: NSIndexPath) {
        self.addEntryController = addEntryController
        self.userInterface = userInterface
        self.indexPathOfEntryToEdit = indexPathOfEntryToEdit
        self.displayEntry = displayEntry
    }

    init(addEntryController: BSAddEntryControllerProtocol, userInterface : BSAddEntryInterfaceProtocol) {
        self.addEntryController = addEntryController
        self.userInterface = userInterface        
    }
    
    func save(entry : BSDisplayExpensesSummaryEntry, successBlock :()->(), failureBlock:(_ error : NSError) -> () )
    {
        let entity = self.entryEntity(fromViewModel: entry)
        
        self.addEntryController.save(entry: entity, successBlock: {
            successBlock()
            }) { (error) in
                failureBlock(error)
        }
    }
    
    func userCancelledEditionOfExistingEntry() {
        self.addEntryController.discardChanges()
    }
        
    func userSelectedNext() {
//        let entry = self.addEntryController.newEntry()
//        self.userInterface.display(entry: entry)
    }
    
    func userInterfaceReadyToDiplayEntry()
    {
        if let entry = self.addEntryController.editingEntry
        {
            // Editing
            self.userInterface.display(entry: entry)
        }
        else
        {
            // Creating
            let entry = BSDisplayExpensesSummaryEntry(title: "", value: "", signOfAmount:.positive, date: DateTimeHelper.dateString(withFormat: DEFAULT_DATE_FORMAT, date: Date()), tag: nil)
            self.userInterface.display(entry: entry)
        }
    }
    
    private func entryEntity(fromViewModel entry: BSDisplayExpensesSummaryEntry) -> BSExpenseEntry {
        let date = DateTimeHelper.date(withFormat: DEFAULT_DATE_FORMAT, stringDate: entry.date)
        let value: NSDecimalNumber
            
        if let enteredValue = entry.value, enteredValue.count > 0 {
            value = BSCurrencyHelper.amountFormatter().number(from: enteredValue) as! NSDecimalNumber
        } else {
            value = NSDecimalNumber(string: "0")
        }
        let category = BSExpenseCategory(name: entry.tag!, iconName: "", color: UIColor.white) // we only need the name to find the coredata entity later
        let entity = BSExpenseEntry(date: date, value:value, description: entry.desc, category: category)
        entity.identifier = entry.identifier
        if entry.isAmountNegative {
            if NSDecimalNumber(string: "0").compare(entity.value) == .orderedAscending {
                // Has to be negative but it's positive, then change it
                entity.value = entity.value.multiplying(by: NSDecimalNumber(string: "-1"))
            }
            
        } else {
            if NSDecimalNumber(string: "0").compare(entity.value) == .orderedDescending {
                // Has to be positive but it's negative, then change it
                entity.value = entity.value.multiplying(by: NSDecimalNumber(string: "-1"))
            }
        }
        return entity
    }
}
