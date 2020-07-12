//
//  TestCoreDataStackHelper.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 29/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreData

class TestCoreDataStackHelper {
    
    static func coreDataContext() -> NSManagedObjectContext {
        let storeName = "expensit-test-data"
        
        CoreDataStackHelper.destroyAllExtensionsForSQLPersistentStoreCoordinator(withName: storeName)
                
        let coreDataHelper = CoreDataStackHelper(persitentStoreType: NSSQLiteStoreType,
                                                 resourceName: "Expenses",
                                                 extension: "momd",
                                                 persistentStoreName: storeName)
        
        return coreDataHelper!.managedObjectContext
    }
}
