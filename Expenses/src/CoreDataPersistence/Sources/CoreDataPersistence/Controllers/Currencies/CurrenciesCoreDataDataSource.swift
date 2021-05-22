//
//  CurrenciesDataSource.swift
//  
//
//  Created by Borja Arias Drake on 22.05.2021..
//

import Foundation
import Combine
import CoreExpenses
import CoreData
import UIKit

public class CurrenciesCoreDataDataSource: CoreDataDataSource, CurrenciesDataSource {
            
    @Published public var selectedCategory: ExpenseCategory?
    public var selectedCategoryPublished : Published<ExpenseCategory?> {_selectedCategory}
    public var selectedCategoryPublisher : Published<ExpenseCategory?>.Publisher {$selectedCategory}
    
    private(set) public var coreDataContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.coreDataContext = context
    }
    
    public func allUsedCurrencies() -> [String] {
        let baseRequest = self.baseRequest(context: coreDataContext)
        baseRequest.propertiesToFetch = ["currencyCode"]
        baseRequest.returnsDistinctResults = true
        do {
            if let expenses = try coreDataContext.fetch(baseRequest) as? [Entry] {
                let currencyCodes = expenses.map { $0.currencyCode }
                return Array(Set(currencyCodes))
            } else {
                return []
            }
        } catch {
            return []
        }
    }
}

