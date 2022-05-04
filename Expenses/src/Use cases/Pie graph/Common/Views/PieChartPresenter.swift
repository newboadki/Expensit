//
//  PieChartPresenter.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import Combine
import DateAndTime
import CoreExpenses

@MainActor
class PieChartPresenter: ObservableObject {
    
    private var chartDataInteractor: BSPieGraphControllerProtocol
    private var month: NSNumber?
    private var year: NSNumber
    
    @Published var sections: [PieChartSectionInfoViewModel]
    var title: String {
        get {            
            if let m = month {
                let calendar = Calendar.current
                let dateComponents = DateComponents(calendar: calendar,
                                                    year: year.intValue,
                                                    month: m.intValue,
                                                    day: nil)
                let sectionDate = calendar.date(from: dateComponents)!
                return DateConversion.string(withFormat: DateFormats.monthYear, from: sectionDate)
            } else {
                return "\(year)"
            }
        }
    }
    
    init(chartDataInteractor: BSPieGraphControllerProtocol, month: NSNumber?, year: NSNumber) {
        self.month = month
        self.year = year
        self.chartDataInteractor = chartDataInteractor
        self.sections = []
    }
    
    func onViewDidAppear() async {
        if let infoSections = await self.chartDataInteractor.expensesByCategory(forMonth: month, year: year) {
            self.sections = await populateViewModel(infoSections: infoSections)
        } else {
            self.sections = [PieChartSectionInfoViewModel]()
        }
    }
    
    nonisolated func populateViewModel(infoSections: [PieChartSectionInfo]) async -> [PieChartSectionInfoViewModel] {
        let handle = Task<[PieChartSectionInfoViewModel], Never> {
            var sum: Double = 0
            return infoSections.enumerated().map { [weak self] (index, info) in
                let endAngle = self!.toDegrees(ratio: DoubleBetweenZeroAndOne(value: Double(info.percentage)) ?? DoubleBetweenZeroAndOne.Zero())
                let model = PieChartSectionInfoViewModel(id: index,
                                                         name: info.name,
                                                         start: sum,
                                                         end: sum + endAngle,
                                                        color: info.color)
                sum += endAngle
                return model
            }
        }
        
        return await handle.value
    }
        
    nonisolated private func toDegrees(ratio: DoubleBetweenZeroAndOne) -> Double {
        guard ratio.value != 0 else {
            return 0
        }
        
        return ratio.value * 360
    }
}
