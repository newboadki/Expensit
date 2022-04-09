//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 19.11.2020..
//

import Foundation

public class DeleteExpenseInteractor {
    private var dataSource: IndividualEntryDataSoure
    
    public init(dataSource: IndividualEntryDataSoure) {
        self.dataSource = dataSource
    }
    
    @discardableResult
    public func delete(_ expense: Expense) async throws -> Bool {
        return try await self.dataSource.delete(expense)
    }
}
