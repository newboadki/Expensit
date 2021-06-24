//
//  CoronaSectionShape.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct Arc: Shape {
    
    var start: Double
    var end: Double
    var animatesEndAngle = false
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(start),
                    endAngle: .degrees(end),
                    clockwise: false)
        return path
    }
}

extension Arc {
    
    var animatableData: Double {
        
        get {
            animatesEndAngle ? end : start
        }

        set {
            if animatesEndAngle {
                end = newValue
            } else {
                start = newValue
            }
        }
    }
}
