//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 08/07/2020.
//

import Foundation

public class AddExpenseInteractor {
    private let dataSource: IndividualEntryDataSoure
    
    public init(dataSource: IndividualEntryDataSoure) {
        self.dataSource = dataSource
    }
    
    public func add(expense: Expense) async throws {
        try await self.dataSource.add(expense: expense)
    }
}
