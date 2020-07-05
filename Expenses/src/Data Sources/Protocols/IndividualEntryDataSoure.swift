//
//  IndividualEntryDataSoure.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

protocol IndividualEntryDataSoure {
    func expense(for identifier: DateComponents) -> Expense?
    func saveChanges(in expense: Expense, with identifier: DateComponents) -> Result<Bool, Error>
}
