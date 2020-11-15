//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 11/10/2020.
//

import Combine
import Foundation

public class YearlyExpensesSummaryInteractor: ExpensesSummaryInteractor {
    
    /*
     * - In the yearly breakdown there's only one group.
     * - The entries of the group are years and a currency.
     * - Exammple: 2014-USD, 2014-GPB, 2015-USD, 2016-USD, 2016-GBP
     * - https://api.exchangeratesapi.io/history?start_at=2014-12-01&end_at=2014-12-01&base=EUR&symbols=HRK,GBP
     */
    public override func entriesForSummary() -> AnyPublisher<[ExpensesGroup], Never> {
        return super.entriesForSummary().map { groups in            
            return groups
        }.eraseToAnyPublisher()
    }
    
    private func add(expense: Expense, to key: DateComponents, sumByYear: inout [DateComponents : Expense]) {
        if let expenseForKey = sumByYear[key] {
            expenseForKey.value = expenseForKey.value.adding(expense.value)
            sumByYear[key] = expenseForKey
        } else {
            sumByYear[key] = expense
        }
    }
    
    private func convert(_ value: NSDecimalNumber, from currency: String, to baseCurrency: String?, using rate:NSDecimalNumber) -> NSDecimalNumber {
        guard (baseCurrency != nil) else {
            return value
        }
        return value.multiplying(by: rate)
    }
}
