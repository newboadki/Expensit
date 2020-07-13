//
//  ExpenseCategory.swift
//  Expenses
//
//  Created by Borja Arias Drake on 15/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

public class ExpenseCategory {

    public var name: String
    public var iconName: String
    public var color: UIColor
        
    public init(name: String, iconName: String, color: UIColor) {
        self.name = name
        self.iconName = iconName
        self.color = color        
    }
}
