//
//  CategoryExtension.swift
//  Expensit
//
//  Created by Borja Arias Drake on 20/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation


extension Date {
    
    public func component(_ component: Calendar.Component) -> UInt {
        return UInt(Calendar(identifier: .gregorian).component(component, from: self))
    }
        
    public var yearNumber: NSNumber {
        get {
            return NSNumber(value: component(.year))
        }
    }
    
    public var monthNumber: NSNumber {
        get {
            return NSNumber(value: component(.month))
        }
    }

    public var dayNumber: NSNumber {
        get {
            return NSNumber(value: component(.day))
        }
    }

    public var minuteNumber: NSNumber {
        get {
            return NSNumber(value: component(.minute))
        }
    }

    public var secondNumber: NSNumber {
        get {
            return NSNumber(value: component(.second))
        }
    }

}
