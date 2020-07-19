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
    func baseRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult>
}

public extension CoreDataDataSource {
    
    func baseRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult> {
        let description = NSEntityDescription.entity(forEntityName: "Entry", in: context)
        let request = Entry.entryFetchRequest()
        request.entity = description
        request.fetchBatchSize = 50
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request as! NSFetchRequest<NSFetchRequestResult>
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
        return try! self.coreDataContext.fetch(fetchRequest).last as! Tag
    }
}
