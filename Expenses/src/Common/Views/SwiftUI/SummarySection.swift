//
//  SummarySection.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import Foundation


class ExpensesSummarySection: Identifiable
{
    var id: Int
    let title : String?
    let entries : [DisplayExpensesSummaryEntry]
    var numberOfEntries : Int  { get { return entries.count } }
    
    init(id: Int, title : String?, entries : [DisplayExpensesSummaryEntry])
    {
        self.id = id
        self.title = title
        self.entries =  entries
    }
}


struct DisplayExpensesSummaryEntry : Identifiable
{
    var id: Int
    var title : String?
    var value : String?
    var signOfAmount : BSNumberSignType
    var isAmountNegative : Bool
    var desc : String?
    var date : String?
    var tag : String?

    init(id: Int, title : String?, value : String?, signOfAmount : BSNumberSignType, date: String?, tag: String?)
    {
        self.id = id
        self.title = title
        self.value = value
        self.desc = title
        self.date = date
        self.signOfAmount =  signOfAmount
        self.isAmountNegative = (signOfAmount == .negative) ? true : false
        self.tag = tag
    }
}
