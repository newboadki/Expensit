//
//  PieChartPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine

class PieChartPresenter: ObservableObject {
    
    @Published var sections: [PieChartSectionInfoViewModel]
    
    
    private var chartDataInteractor: BSExpensesSummaryPieGraphController
    private var month: NSNumber?
    private var year: NSNumber
    var title: String {
        get {            
            if let m = month {
                return "\(m)/\(year)"
            } else {
                return "\(year)"
            }
        }
    }
    
    init(chartDataInteractor: BSExpensesSummaryPieGraphController, month: NSNumber?, year: NSNumber) {
        self.month = month
        self.year = year
        self.chartDataInteractor = chartDataInteractor
        
        if let infoSections = self.chartDataInteractor.expensesByCategory(forMonth: month, year: year) {
            var sum: Double = 0
            self.sections = [PieChartSectionInfoViewModel]()
            self.sections = infoSections.enumerated().map { [weak self] (index, info) in
                let endAngle = self!.toDegrees(ratio: DoubleBetweenZeroAndOne(value: Double(info.percentage)) ?? DoubleBetweenZeroAndOne.Zero())
                let model = PieChartSectionInfoViewModel(id: index,
                                                         name: info.name,
                                                         start: sum,
                                                         end: sum + endAngle,
                                                        color: info.color)
                
                
                print("\(info.percentage) -> from \(sum) to \(sum + endAngle).")
                sum += endAngle
                return model
            }
        } else {
            self.sections = [PieChartSectionInfoViewModel]()
        }
    }
        
    private func toDegrees(ratio: DoubleBetweenZeroAndOne) -> Double {
        guard ratio.value != 0 else {
            return 0
        }
        
        return ratio.value * 360
    }

}