//
//  BSEntryEntityGroup.swift
//  Expenses
//
//  Created by Borja Arias Drake on 13/01/2018.
//  Copyright © 2018 Borja Arias Drake. All rights reserved.
//

import UIKit


/// This class is simply a container of Expense entry entities groupped by a key.
/// They usually represent sections of related entry entities.
class ExpensesGroup: NSObject, ObservableObject
{
    let groupKey: String
    @objc let entries: [Expense]
    
    @objc init(key: String, entries: [Expense])
    {
        self.groupKey = key
        self.entries = entries
        super.init()
    }
}
