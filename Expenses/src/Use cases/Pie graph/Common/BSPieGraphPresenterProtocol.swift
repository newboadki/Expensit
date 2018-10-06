//
//  BSPieGraphPresenterProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSPieGraphPresenterProtocol
{    
    func categories() -> [BSExpenseCategory]?
    func sections() -> [BSPieChartSectionInfo]?
}
