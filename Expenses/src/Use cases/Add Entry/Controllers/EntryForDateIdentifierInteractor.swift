//
//  EntryForDateComponentsInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

class EntryForDateComponentsInteractor {
    private var dataSource: IndividualExpensesDataSource
    
    init(dataSource: IndividualExpensesDataSource) {
        self.dataSource = dataSource
    }
    
    func entry(for identifier: DateComponents) -> Expense? {
        return self.dataSource.expense(for: identifier)
    }
}
