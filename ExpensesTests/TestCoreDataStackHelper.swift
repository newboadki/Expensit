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
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    lazy var managedObjectModel: NSManagedObjectModel = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
            return managedObjectModel
        }()
    
    public static func context(_ completion: @escaping (Result<NSManagedObjectContext, Error>) -> ()) {
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
        let persistentContainer = NSPersistentContainer(name: "Expenses")
        
        let desc = NSPersistentStoreDescription(url: docsURL)
        desc.shouldAddStoreAsynchronously = false
        persistentContainer.persistentStoreDescriptions = [desc]
        
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(persistentContainer.viewContext))
            }
        }        
    }
    
    public func context_sync() -> NSManagedObjectContext {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // Delete
        let sqliteURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite")
        let shmURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite-shm")
        let walURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite-wal")
        
        do {
            try FileManager.default.removeItem(at: sqliteURL)
            try FileManager.default.removeItem(at: shmURL)
            try FileManager.default.removeItem(at: walURL)
        }catch {
            print(error)
        }

        // Create
        let docsURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite")
        let persistentContainer = NSPersistentContainer(name: "Expenses", managedObjectModel: self.managedObjectModel)
        
        let desc = NSPersistentStoreDescription(url: docsURL)
        desc.shouldAddStoreAsynchronously = false
        persistentContainer.persistentStoreDescriptions = [desc]
        
        var result: NSManagedObjectContext? = nil
                
        persistentContainer.loadPersistentStores() { (description, error) in
            if let _ = error {
                result = nil
            } else {
                result = persistentContainer.viewContext
            }
            self.semaphore.signal()
        }

        semaphore.wait()
        return result!
    }
    
    public static func delete() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let docsURL = documentsDirectory.appendingPathComponent("test-expensesDataBase.sqlite")
        
    }
}
