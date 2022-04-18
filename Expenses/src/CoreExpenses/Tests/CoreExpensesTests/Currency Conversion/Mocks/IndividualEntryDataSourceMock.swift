//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 27.04.2021..
//

import CoreExpenses
import Foundation

class IndividualEntryDataSourceMock: IndividualEntryDataSoure {
            
    var expensesRequestedToSave: [Expense]?
            
    init() {
        
    }
    
    func expense(for identifier: DateComponents) async -> Expense? {
        return nil
    }
    
    func saveChanges(in expense: Expense, with identifier: DateComponents) async throws {
    }
    
    func saveChanges(in expenses: [Expense]) async throws {
        self.expensesRequestedToSave = expenses
    }
    
    func add(expense: Expense) async throws {
    }
    
    func delete(_ expense: Expense) async throws {
    }
}
