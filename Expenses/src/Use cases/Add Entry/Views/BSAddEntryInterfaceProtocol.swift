//
//  BSAddEntryInterfaceProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 04/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSAddEntryInterfaceProtocol {
    
    @objc(displayEntry:)
    func display(entry : BSDisplayExpensesSummaryEntry)
}
