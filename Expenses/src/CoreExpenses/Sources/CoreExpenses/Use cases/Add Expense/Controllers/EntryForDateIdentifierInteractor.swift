//
//  EntryForDateComponentsInteractor.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/07/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public class EntryForDateComponentsInteractor {
    private let dataSource: IndividualEntryDataSoure
    
    public init(dataSource: IndividualEntryDataSoure) {
        self.dataSource = dataSource
    }
    
    public func entry(for identifier: DateComponents) async -> Expense? {
        await self.dataSource.expense(for: identifier)
    }
}
