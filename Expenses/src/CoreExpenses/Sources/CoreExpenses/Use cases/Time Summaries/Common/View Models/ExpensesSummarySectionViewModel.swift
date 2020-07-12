//
//  SummarySection.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation

public class ExpensesSummarySectionViewModel: Identifiable
{
    public let id: DateComponents
    public let title : String?
    public let entries : [ExpensesSummaryEntryViewModel]
    public var numberOfEntries : Int  { get { return entries.count } }
        
    public init(id: DateComponents, title : String?, entries : [ExpensesSummaryEntryViewModel])
    {
        self.id = id
        self.title = title
        self.entries =  entries
    }
}
