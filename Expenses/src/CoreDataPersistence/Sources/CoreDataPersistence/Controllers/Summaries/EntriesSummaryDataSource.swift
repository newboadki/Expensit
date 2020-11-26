//
//  EntriesSummaryDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine
import CoreExpenses
import CoreData

public protocol CoreDataDataSource {
    var coreDataContext: NSManagedObjectContext {get}
    func baseRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult>
    func isExchangeRateToBaseApproximated() -> Bool
}

public extension CoreDataDataSource {
    
    func baseRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult> {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: context)
        let request = Entry.entryFetchRequest()
        request.entity = description
        request.fetchBatchSize = 50
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
    
    func save() -> Bool {
        guard let _ = try? self.coreDataContext.save() else {
            return false
        }
        return true
    }
    
    func isExchangeRateToBaseApproximated() -> Bool {
        let baseRequest = self.baseRequest(context: coreDataContext)
        baseRequest.predicate = NSPredicate(format: "isExchangeRateUpToDate = false")
        let results = try! coreDataContext.fetch(baseRequest)
        return (results.count > 0)
    }
}

public protocol PerformsCoreDataRequests {
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {get}
    var coreDataContext: NSManagedObjectContext {get}
}

public extension PerformsCoreDataRequests {
    func performRequest() -> [NSFetchedResultsSectionInfo]? {        
        if let controller = self.fetchedResultsController {
            do
            {
                try controller.performFetch()
                return controller.sections
            }
            catch
            {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func filter(by category: ExpenseCategory?) {
        if let category = category {
            let tag = self.tag(forName: category.name)
            self.modify(fetchRequest: fetchedResultsController!.fetchRequest, toFilterByCategory: tag)
        } else {
            self.modify(fetchRequest: fetchedResultsController!.fetchRequest, toFilterByCategory: nil)
        }
    }
    
    func modify(fetchRequest: NSFetchRequest<NSFetchRequestResult>, toFilterByCategory tag: Tag?) {
        var predicate: NSPredicate? = nil
        if let t = tag {
            predicate = NSPredicate(format: "tag.name LIKE %@", t.name)
        }
        fetchRequest.predicate = predicate
    }
    
    func tag(forName name: String) -> Tag {
        let fetchRequest = Tag.tagFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name LIKE %@", name)
        return try! self.coreDataContext.fetch(fetchRequest).last!
    }
}
