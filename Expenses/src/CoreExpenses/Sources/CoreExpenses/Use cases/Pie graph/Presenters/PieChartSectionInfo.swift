//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 11/07/2020.
//

import Foundation
import UIKit

public struct PieChartSectionInfo {
    public var name: String
    public var percentage: Double
    public var color: UIColor
    
    public init(name: String, percentage: Double, color: UIColor) {
        self.name = name
        self.percentage = percentage
        self.color = color
    }
}
