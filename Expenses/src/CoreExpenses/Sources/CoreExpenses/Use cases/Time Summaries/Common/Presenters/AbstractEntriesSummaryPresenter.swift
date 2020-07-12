//
//  ExpensesSummaryPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 25/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation
import Combine


/// The presenter classes for the expense summaries return the view-models that is the purely-visual data that certain view needs. 
public class AbstractEntriesSummaryPresenter: ObservableObject {
    
    // MARK: - Properties
    @Published public var sections: [ExpensesSummarySectionViewModel]
    public var title: String
    
    private(set) public var interactor: ExpensesSummaryInteractorProtocol
    private var subscription: AnyCancellable!
        
    // MARK: - Initializers
    
    public init(interactor: ExpensesSummaryInteractorProtocol) {
        self.sections = [ExpensesSummarySectionViewModel]()
        self.title = ""
        self.interactor = interactor
        self.bind()
    }
    
    deinit {
        self.subscription.cancel()
    }


    // MARK: - API
    
    public func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySectionViewModel]> {
        fatalError("Not implemented.")
    }
    
    public func numberOfRows(in section: ExpensesSummarySectionViewModel) -> Int {
        Int(ceil(Double(section.entries.count)/Double(preferredNumberOfColumns())))
    }

    public func preferredNumberOfColumns() -> Int {
        return 0
    }

    public func numberOfColumns(in rowIndex: Int, section: ExpensesSummarySectionViewModel) -> Int {    
        if rowIndex < numberOfRows(in: section)-1 {
            return self.preferredNumberOfColumns()
        } else {
            if (section.entries.count % preferredNumberOfColumns()) != 0 {
                return (section.entries.count % preferredNumberOfColumns())
            } else {
                return self.preferredNumberOfColumns()
            }
        }        
    }
    
    // MARK: - Private methods
    
    private func bind() {
        self.subscription = displayDataFromEntriesForSummary().sink(receiveValue: { viewSections in
            self.sections = viewSections
        })
    }
    
}
