//
//  ExpensesSummaryInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 25/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

/* This use case consists of making a single query to the data source. */
public class ExpensesSummaryInteractor: ExpensesSummaryInteractorProtocol {
    
    private(set) var dataSource: EntriesSummaryDataSource
    
    public init(dataSource: EntriesSummaryDataSource) {
        self.dataSource = dataSource
    }
    
    public func entriesForSummary() -> AnyPublisher<[ExpensesGroup], Never> {
        self.dataSource.groupedExpensesPublisher.eraseToAnyPublisher()
    }    
}
