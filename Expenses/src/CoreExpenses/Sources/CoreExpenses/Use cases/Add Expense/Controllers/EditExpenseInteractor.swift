//
//  EditExpenseInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public class EditExpenseInteractor {
    private let dataSource: IndividualEntryDataSoure
    
    public init(dataSource: IndividualEntryDataSoure) {
        self.dataSource = dataSource
    }
    
    public func saveChanges(in expense: Expense, with identifier: DateComponents) async throws -> Bool {
        try await self.dataSource.saveChanges(in: expense, with: identifier)
    }
    
    @discardableResult
    public func saveChanges(in expenses: [Expense]) async throws -> Bool {
        try await self.dataSource.saveChanges(in: expenses)
    }
}
