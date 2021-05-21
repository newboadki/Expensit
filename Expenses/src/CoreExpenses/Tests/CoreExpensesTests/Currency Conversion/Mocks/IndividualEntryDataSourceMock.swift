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
    
    func expense(for identifier: DateComponents) -> Expense? {
        return nil
    }
    
    func saveChanges(in expense: Expense, with identifier: DateComponents) -> Result<Bool, Error> {
        return .success(true)
    }
    
    func saveChanges(in expenses: [Expense]) -> Result<Bool, Error> {
        self.expensesRequestedToSave = expenses
        return .success(true)
    }
    
    func add(expense: Expense) -> Result<Bool, Error> {
        return .success(true)
    }
    
    func delete(_ expense: Expense) -> Result<Bool, Error> {
        return .success(true)
    }
}
