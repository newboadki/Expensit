//
//  CategoryPieChartNavigationCoordinator.swift
//  Expensit
//
//  Created by Borja Arias Drake on 19/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI


protocol GridViewSectionHeaderNavigationCoordinator {
    associatedtype T: View
    func nextView(forIdentifier currentViewIdentifier: String, params: Any?, isPresented: Binding<Bool>) -> T
}

class CategoryPieChartNavigationCoordinator: GridViewSectionHeaderNavigationCoordinator {
    private var fetchController: BSCoreDataFetchController
    
    init(fetchController: BSCoreDataFetchController) {
        self.fetchController = fetchController
    }
    
    // MARK: - GridViewSectionHeaderNavigationCoordinator
    
    func nextView(forIdentifier currentViewIdentifier: String, params: Any?, isPresented: Binding<Bool>) -> PieChartView {
        guard let p = params as? (year: Int, month: Int?) else {
            return PieChartView(isPresented: isPresented,
                                presenter: PieChartPresenter(chartDataInteractor: BSExpensesSummaryPieGraphController(dataProvider: self.fetchController),
                                                             month: 0,
                                                             year: 0))
        }
        
        return PieChartView(isPresented: isPresented,
                            presenter: PieChartPresenter(chartDataInteractor: BSExpensesSummaryPieGraphController(dataProvider: self.fetchController),
                                                         month: (p.month != nil) ? NSNumber(integerLiteral: Int(p.month!)) : nil,
                                                         year: NSNumber(integerLiteral: Int(p.year))))
    }
}
