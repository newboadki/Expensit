//
//  CoreDataStack.swift
//  Expensit
//
//  Created by Borja Arias Drake on 12/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreData

public struct CoreDataStack {
    
    public static func context(_ completion: @escaping (Result<NSManagedObjectContext, Error>) -> ()) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let docsURL = documentsDirectory.appendingPathComponent("expensesDataBase.sqlite")
        let persistentContainer = NSPersistentContainer(name: "Expenses")
        persistentContainer.persistentStoreDescriptions = [NSPersistentStoreDescription(url: docsURL)]
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                completion(.failure(error))
                return
            }            
            completion(.success(persistentContainer.newBackgroundContext()))
        }

    }
}
