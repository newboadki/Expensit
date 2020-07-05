//
//  ShowMonthlyEntriesControllerProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 18/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


/// Expenses Summary screens' controller objects orchestrate the different sub use cases related to the
/// bigger use case to present an expense summary to the user.
protocol ExpensesSummaryInteractorProtocol {
    
    /// Fetches a collection of entries, groupped by sectionNameKeyPath
    ///
    /// - Returns: A publisher of grouped expenses
    func entriesForSummary() -> Published<[ExpensesGroup]>.Publisher
}
