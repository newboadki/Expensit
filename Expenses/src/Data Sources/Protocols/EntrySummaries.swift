//
//  EntrySummaries.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

protocol EntriesSummaryDataSource: PerformsCoreDataRequests {
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {get}
}
