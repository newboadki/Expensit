//
//  IndividualEntryDataSoure.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public protocol IndividualEntryDataSoure {
    func expense(for identifier: DateComponents) async -> Expense?
    func saveChanges(in expense: Expense, with identifier: DateComponents) async throws -> Bool
    func saveChanges(in expenses: [Expense]) async throws -> Bool
    func add(expense: Expense) async throws
    func delete(_ expense: Expense) async throws -> Bool
}
