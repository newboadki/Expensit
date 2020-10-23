//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 15/10/2020.
//

import Combine

public class MonthlyExpensesSummaryInteractor: ExpensesSummaryInteractor {
    
    public override func entriesForSummary() -> AnyPublisher<[ExpensesGroup], Never> {
        return super.entriesForSummary().map { group in
            return group
        }.eraseToAnyPublisher()
    }
}

