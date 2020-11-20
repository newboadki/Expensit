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
public class AbstractEntriesSummaryPresenter<SubscribeOn: Scheduler, ReceiveOn: Scheduler>: ObservableObject {
    
    // MARK: - Properties
    @Published public var sections: [ExpensesSummarySectionViewModel]
    public var title: String
    
    private(set) public var interactor: ExpensesSummaryInteractorProtocol
    private var subscription: AnyCancellable!
    
    private var subscriptionScheduler: SubscribeOn
    private var receiveOnScheduler: ReceiveOn
        
    // MARK: - Initializers
    
    public init(interactor: ExpensesSummaryInteractorProtocol,
                subscriptionScheduler: SubscribeOn,
                receiveOnScheduler: ReceiveOn) {
        self.sections = [ExpensesSummarySectionViewModel]()
        self.title = ""
        self.interactor = interactor
        self.subscriptionScheduler = subscriptionScheduler
        self.receiveOnScheduler = receiveOnScheduler
    }
    
    deinit {
        self.subscription.cancel()
    }


    // MARK: - API
    
    public func displayDataFromEntriesForSummary() -> AnyPublisher<[ExpensesSummarySectionViewModel], Never> {
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
    
    public func bind() {
        self.subscription = self.displayDataFromEntriesForSummary()
            .subscribe(on: subscriptionScheduler)
            .receive(on: receiveOnScheduler)
            .sink(receiveValue: { viewSections in
                self.sections = viewSections
            })
    }

    public func unbind() {
        self.subscription.cancel()
    }

}
