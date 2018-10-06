//
//  BSDisplaySectionData.swift
//  Expenses
//
//  Created by Borja Arias Drake on 27/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc enum BSNumberSignType : Int
{
    case zero = 0, positive, negative
}


class BSDisplayExpensesSummarySection : NSObject
{
    let title : String?
    let entries : [BSDisplayExpensesSummaryEntry]
    var numberOfEntries : Int  { get { return entries.count } }
    
    init(title : String?, entries : [BSDisplayExpensesSummaryEntry])
    {
        self.title = title
        self.entries =  entries
        super.init()
    }
}

// FIX-ME:
class BSDisplayExpensesSummaryEntry : NSObject
{
    var identifier: NSCopying?
    var title : String?
    var value : String?
    var signOfAmount : BSNumberSignType
    var isAmountNegative : Bool

    // FIX-ME: This should be in a different view model
    var desc : String?
    var date : String?
    var tag : String?

    
    
    init(title : String?, value : String?, signOfAmount : BSNumberSignType, date: String?, tag: String?)
    {
        self.title = title
        self.value = value
        self.desc = title
        self.date = date
        self.signOfAmount =  signOfAmount
        self.isAmountNegative = (signOfAmount == .negative) ? true : false
        self.tag = tag
        super.init()
    }
}
