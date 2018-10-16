//
//  ExpenseCategory.swift
//  Expenses
//
//  Created by Borja Arias Drake on 15/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class ExpenseCategory : NSObject {

    var name: String
    var iconName: String
    var color: UIColor
    
    init(name: String, iconName: String, color: UIColor) {
        self.name = name
        self.iconName = iconName
        self.color = color
        super.init()
    }
}
