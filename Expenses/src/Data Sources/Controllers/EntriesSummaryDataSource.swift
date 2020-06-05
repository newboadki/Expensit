//
//  EntriesSummaryDataSource.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

protocol PerformsCoreDataRequests {
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {get}
    var coreDataController: BSCoreDataController {get}
}

extension PerformsCoreDataRequests {
    func performRequest() -> [NSFetchedResultsSectionInfo]? {
        do
        {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.sections
        }
        catch
        {
            return nil
        }
    }
    
    func filter(by category: ExpenseCategory?) {
        if let category = category {
            let tag = self.coreDataController.tag(forName: category.name)
            self.coreDataController.modifyfetchRequest((fetchedResultsController.fetchRequest), toFilterByCategory: tag)
        } else {
            self.coreDataController.modifyfetchRequest((fetchedResultsController.fetchRequest), toFilterByCategory: nil)
        }
    }
}

protocol EntriesSummaryDataSource: PerformsCoreDataRequests {
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {get}            
}
