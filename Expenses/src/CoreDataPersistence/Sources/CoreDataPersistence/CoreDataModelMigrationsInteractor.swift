//
//  CoreDataModelMigrationsInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 12/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreData

class CoreDataModelMigrationsInteractor {
    
    init() {
        // add data source dependencies
    }
    
    func applyPendingMigrations(to model: NSManagedObjectModel) {
        guard let version = model.versionIdentifiers.first,
            let currentVersion = version as? String else {
            return
        }
        let v = NSDecimalNumber(string: currentVersion)
        for i in 0...v.intValue {
            
        }
        
    }
}
