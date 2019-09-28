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


@objc class BSDisplayExpensesSummarySection : NSObject
{
    @objc let title : String?
    @objc let entries : [BSDisplayExpensesSummaryEntry]
    @objc var numberOfEntries : Int  { get { return entries.count } }
    
    @objc init(title : String?, entries : [BSDisplayExpensesSummaryEntry])
    {
        self.title = title
        self.entries =  entries
        super.init()
    }
}

// FIX-ME:
@objc class BSDisplayExpensesSummaryEntry : NSObject
{
    @objc var identifier: NSCopying?
    @objc var title : String?
    @objc var value : String?
    @objc var signOfAmount : BSNumberSignType
    @objc var isAmountNegative : Bool

    // FIX-ME: This should be in a different view model
    @objc var desc : String?
    @objc var date : String?
    @objc var tag : String?

    @objc init(title : String?, value : String?, signOfAmount : BSNumberSignType, date: String?, tag: String?)
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
