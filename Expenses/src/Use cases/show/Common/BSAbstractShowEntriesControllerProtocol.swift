//
//  ShowMonthlyEntriesControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


/// Summary screens' controller objects have a number of characteristics collected in this protocol.
@objc protocol BSAbstractShowEntriesControllerProtocol {
    
    /// Changes internal configuration to filter accordanly next time entries for summary gets called.
    ///
    /// - Parameter category: The category to filter by.
    func filter(by category : BSExpenseCategory?)
    
    
    /// Fetches a collection of entries, groupped by sectionNameKeyPath
    ///
    /// - Returns: An array of EntryEntityGroup an entity container grouped by a key
    func entriesForSummary() -> [BSEntryEntityGroup]
    
    /// Fetches an image for a given category
    ///
    /// - Parameter category: The category to search an image for.
    /// - Returns: An image. Nil if there was an error.
    func image(for category: BSExpenseCategory?) -> UIImage?
    
    
    /// A string descriptor for the sections in the fetched results.
    /// This descriptor is currently coupled with CoreData. It corresponds with a field
    /// in the entities, to be able to effectively group by. However, this is an implementation detail
    /// that users of the controllers don't need to understand.
    ///
    /// - Returns: Descriptor of a section in the summary result.
    @objc optional func sectionNameKeyPath() -> String?
    
    
    /// TODO: Do not expose this. It is here to facilitate the tests, which need to be modified to 
    /// check for the expectations.
    @objc optional var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {get}
}
