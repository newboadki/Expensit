//
//  CategoryExtension.swift
//  Expensit
//
//  Created by Borja Arias Drake on 20/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation


extension Date {
    
    public func component(_ component: Calendar.Component) -> Int {
        return Calendar(identifier: .gregorian).component(component, from: self)
    }
}
