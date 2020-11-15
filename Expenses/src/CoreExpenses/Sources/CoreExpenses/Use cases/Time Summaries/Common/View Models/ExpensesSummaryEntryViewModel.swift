//
//  ExpensesSummaryEntryViewModel.swift
//  Expensit
//
//  Created by Borja Arias Drake on 01/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public enum BSNumberSignType : Int
{
    case zero = 0, positive, negative
}


public struct ExpensesSummaryEntryViewModel : Identifiable
{
    public var id: DateComponents
    public var title : String?
    public var value : String?
    public var signOfAmount : BSNumberSignType
    public var isAmountNegative : Bool
    public var desc : String?
    public var date : String?
    public var tag : String?
    public var tagId : Int
    public var dateTime: Date
    public var currencyCode: String
    public var currencyCodeId: Int

    public init(id: DateComponents, title : String?, value : String?, signOfAmount : BSNumberSignType, date: String?, tag: String?, tagId: Int = 2, dateTime: Date = Date(), currencyCode: String, currencyCodeId: Int = 0)
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
        self.currencyCode = currencyCode
        self.currencyCodeId = currencyCodeId
    }
}
