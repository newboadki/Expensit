//
//  ExpensesSummaryInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 25/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

/* This use case consists of making a single query to the data source*/
class ExpensesSummaryInteractor {
    
    private var dataSource: EntriesSummaryDataSource
    
    init(dataSource: EntriesSummaryDataSource) {
        self.dataSource = dataSource
    }
    
    func entriesForSummary() -> Published<[ExpensesGroup]>.Publisher {
        self.dataSource.groupedExpensesPublisher                
    }    
}
