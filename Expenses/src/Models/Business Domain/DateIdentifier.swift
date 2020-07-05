//
//  DateIdentifier.swift
//  Expensit
//
//  Created by Borja Arias Drake on 20/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

struct DateIdentifier: Hashable, Comparable {
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int? = nil
    var minute: Int? = nil
    var second: Int? = nil
    
    // MARK:- Comparable
    
    static func < (lhs: DateIdentifier, rhs: DateIdentifier) -> Bool {
        guard let ly = lhs.year, let ry = rhs.year else {
            return false
        }
        guard ly == ry else {
            return ly < ry
        }
        
        guard let lm = lhs.month, let rm = rhs.month else {
            return false
        }
        guard lm == rm else {
            return lm < rm
        }
        
        guard let ld = lhs.day, let rd = rhs.day else {
            return false
        }
        guard ld == rd else {
            return ld < rd
        }
        
        guard let lh = lhs.hour, let rh = rhs.hour else {
            return false
        }
        guard lh == rh else {
            return lh < rh
        }
        
        guard let lmi = lhs.minute, let rmi = rhs.minute else {
            return false
        }
        guard lmi == rmi else {
            return lmi < rmi
        }
        
        guard let ls = lhs.second, let rs = rhs.second else {
            return false
        }
        guard ls == rs else {
            return ls < rs
        }
        
        return true
    }

}
