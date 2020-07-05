//
//  ExpensesSummaryEntryViewModel.swift
//  Expensit
//
//  Created by Borja Arias Drake on 01/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

struct ExpensesSummaryEntryViewModel : Identifiable
{
    var id: DateComponents
    var title : String?
    var value : String?
    var signOfAmount : BSNumberSignType
    var isAmountNegative : Bool
    var desc : String?
    var date : String?
    var tag : String?
    var tagId : Int
    var dateTime: Date

    init(id: DateComponents, title : String?, value : String?, signOfAmount : BSNumberSignType, date: String?, tag: String?, tagId: Int = 2, dateTime: Date = Date())
    {
        self.id = id
        self.title = title
        self.value = value
        self.desc = title
        self.date = date
        self.signOfAmount =  signOfAmount
        self.isAmountNegative = (signOfAmount == .negative) ? true : false
        self.tag = tag
        self.tagId = tagId
        self.dateTime = dateTime
    }
}
