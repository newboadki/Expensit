//
//  ExpensesSummaryPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 25/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class AbstractEntriesSummaryPresenter: ObservableObject {
        
    @Published var sections: [ExpensesSummarySectionViewModel]
    private(set) var interactor: ExpensesSummaryInteractor
    private var subscription: AnyCancellable!
    
    var title: String
    
    init(interactor: ExpensesSummaryInteractor) {
        self.sections = [ExpensesSummarySectionViewModel]()
        self.title = ""
        self.interactor = interactor
        self.bind()
    }
    
    deinit {
        self.subscription.cancel()
    }

    private func bind() {
        self.subscription = displayDataFromEntriesForSummary().sink(receiveValue: { viewSections in
            self.sections = viewSections
        })
    }
    
    func displayDataFromEntriesForSummary() -> Publishers.Map<Published<[ExpensesGroup]>.Publisher, [ExpensesSummarySectionViewModel]> {
        fatalError("Not implemented.")
    }
    
    func numberOfRows(in section: ExpensesSummarySectionViewModel) -> Int {
        Int(ceil(Double(section.entries.count)/Double(preferredNumberOfColumns())))
    }

    func preferredNumberOfColumns() -> Int {
        return 0
    }

    func numberOfColumns(in rowIndex: Int, section: ExpensesSummarySectionViewModel) -> Int {    
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
}
