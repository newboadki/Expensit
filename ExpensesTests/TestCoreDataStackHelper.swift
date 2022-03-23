//
//  TestCoreDataStackHelper.swift
//  ExpensesTests
//
//  Created by Borja Arias Drake on 29/09/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation
import CoreData
import CoreExpenses
import CoreDataPersistence

public class TestCoreDataStack {
    
    static let shared = TestCoreDataStack()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
    }()
    
    public func context() async -> Result<NSManagedObjectContext, Error> {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // Delete
        let sqliteURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite")
        let shmURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite-shm")
        let walURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.wal")
        
        _ = try? FileManager.default.removeItem(at: sqliteURL)
        _ = try? FileManager.default.removeItem(at: shmURL)
        _ = try? FileManager.default.removeItem(at: walURL)
        
        // Create
        let docsURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite")
        let persistentContainer = NSPersistentContainer(name: "Expenses", managedObjectModel: self.managedObjectModel)
        
        let desc = NSPersistentStoreDescription(url: docsURL)
        desc.shouldAddStoreAsynchronously = true
        persistentContainer.persistentStoreDescriptions = [desc]
       
        return await withCheckedContinuation { continuation in
            persistentContainer.loadPersistentStores() { (description, error) in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                } else {
                    continuation.resume(returning: .success(persistentContainer.viewContext))
                }
            }
        }
    }
}
