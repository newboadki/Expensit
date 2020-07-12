//
//  ExpenseCategory.swift
//  Expenses
//
//  Created by Borja Arias Drake on 15/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

@objc
public class ExpenseCategory : NSObject {

    @objc public var name: String
    @objc public var iconName: String
    @objc public var color: UIColor
    
    @objc(initWithName:iconName:color:)
    public init(name: String, iconName: String, color: UIColor) {
        self.name = name
        self.iconName = iconName
        self.color = color
        super.init()
    }
}
