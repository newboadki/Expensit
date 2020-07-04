//
//  EditExpenseInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 04/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class EditExpenseInteractor {
    private var dataSource: IndividualExpensesDataSource
    
    init(dataSource: IndividualExpensesDataSource) {
        self.dataSource = dataSource
    }
    
    func saveChanges(in expense: Expense, with identifier: DateIdentifier) -> Result<Bool, Error> {
        return self.dataSource.saveChanges(in: expense, with: identifier)
    }
}
