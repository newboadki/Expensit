//
//  ShowMonthlyEntriesControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


/// Expenses Summary screens' controller objects orchestrate the different sub use cases related to the
/// bigger use case to present an expense summary to the user.
@objc protocol BSAbstractShowEntriesControllerProtocol {
    
    /// Fetches a collection of entries, groupped by sectionNameKeyPath
    ///
    /// - Returns: An array of EntryEntityGroup an entity container grouped by a key
    func entriesForSummary() -> [ExpensesGroup]
    
    /// Fetches an image for a given category
    ///
    /// - Parameter category: The category to search an image for.
    /// - Returns: An image. Nil if there was an error.
    func image(for category: ExpenseCategory?) -> UIImage?
    
    /// Changes internal configuration to filter accordanly next time entries for summary gets called.
    ///
    /// - Parameter category: The category to filter by.
    func filter(by category : ExpenseCategory?)
}
