//
//  IndividualEntryDataSoure.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public protocol IndividualEntryDataSoure {
    func expense(for identifier: DateComponents) -> Expense?
    func saveChanges(in expense: Expense, with identifier: DateComponents) -> Result<Bool, Error>
    func saveChanges(in expenses: [Expense]) -> Result<Bool, Error>
    func add(expense: Expense) -> Result<Bool, Error>
    func delete(_ expense: Expense) -> Result<Bool, Error>
}
