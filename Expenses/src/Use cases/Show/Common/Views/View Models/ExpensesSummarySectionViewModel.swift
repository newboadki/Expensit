//
//  SummarySection.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation

class ExpensesSummarySectionViewModel: Identifiable
{
    var id: Int
    let title : String?
    let entries : [ExpensesSummaryEntryViewModel]
    var numberOfEntries : Int  { get { return entries.count } }
    
    init(id: Int, title : String?, entries : [ExpensesSummaryEntryViewModel])
    {
        self.id = id
        self.title = title
        self.entries =  entries
    }
}