//
//  ExpenseCategory.swift
//  Expenses
//
//  Created by Borja Arias Drake on 15/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

@objc class ExpenseCategory : NSObject {

    @objc var name: String
    @objc var iconName: String
    @objc var color: UIColor
    
    @objc init(name: String, iconName: String, color: UIColor) {
        self.name = name
        self.iconName = iconName
        self.color = color
        super.init()
    }
}
