//
//  DoubleBetweenZeroAndOne.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

public struct DoubleBetweenZeroAndOne: Comparable {
    
    public static func Zero() -> DoubleBetweenZeroAndOne {
        return DoubleBetweenZeroAndOne()
    }
        
    private(set) public var value: Double = 0
    
    // MARK: - Initializers
    
    public init?(value: Double) {
        guard value >= 0 && value <= 1 else {
            return nil
        }
        self.value = value
    }
    
    public init() {}
    
    
    // MARK: - Comparable
    
    public static func < (lhs: DoubleBetweenZeroAndOne, rhs: DoubleBetweenZeroAndOne) -> Bool {
        return lhs.value < rhs.value
    }
}
