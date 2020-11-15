//
//  EntrySummaries.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine

public protocol EntriesSummaryDataSource {
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {get}
    func expensesGroups() -> [ExpensesGroup]
}


