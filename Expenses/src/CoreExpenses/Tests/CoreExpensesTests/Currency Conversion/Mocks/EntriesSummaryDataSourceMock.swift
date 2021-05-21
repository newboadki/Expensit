//
//  File 2.swift
//  
//
//  Created by Borja Arias Drake on 26.04.2021..
//

@testable import CoreExpenses
import Combine

class EntriesSummaryDataSourceMock: EntriesSummaryDataSource {
        
    var groups: [ExpensesGroup]
    private var isAproximated: Bool
    
    @Published var groupedExpenses = [ExpensesGroup]()
    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
    
    init(groups: [ExpensesGroup], isExchangeRateToBaseApproximated: Bool) {
        self.groups = groups
        self.isAproximated = isExchangeRateToBaseApproximated        
    }

    func expensesGroups() -> [ExpensesGroup] {
        groups
    }
    
    func isExchangeRateToBaseApproximated() -> Bool {
        isAproximated
    }
}
