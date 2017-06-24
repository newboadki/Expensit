//
//  BSGraphLinePresenterProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSGraphLinePresenterProtocol
{
    var section : String { get set }
    
    func graphTitle() -> String
    
    func income() -> [AnyObject]
    
    
    /// Positive Values representing the expenses
    ///
    /// - Discussion: The values must be positive
    /// - Returns: Array of positive values
    func expenses() -> [AnyObject]
    
    
    /// X-Axis labels
    ///
    /// - Returns: Array of labels
    func abscissaValues() -> [String]
}
