//
//  PieChartSectionInfoViewModel.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Foundation

struct PieChartSectionInfoViewModel: Identifiable {
    var id: Int
    var name: String
    var start: Double
    var end: Double 
    var color: UIColor
}
