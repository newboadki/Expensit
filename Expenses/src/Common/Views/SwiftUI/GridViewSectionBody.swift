//
//  GridViewSectionBody.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct GridViewSectionBody<NC: NavigationCoordinator>: View {

    @ObservedObject var presenter: AbstractEntriesSummaryPresenter
    var section: ExpensesSummarySection
    var navigationCoordinator: NC
 
    var body: some View {
        VStack {            
            ForEach(0..<self.presenter.numberOfRows(in: section), id:\.self) { rowIndex in
                HStack(alignment: .center, spacing: 0) {
                    GridViewSectionBodyRow<NC>(section: self.section,
                                               rowIndex: rowIndex,
                                               navigationCoordinator: self.navigationCoordinator,
                                               numberOfColumns: self.presenter.numberOfColumns(in: rowIndex, section:self.section),
                                               preferredNumberOfColumns: self.presenter.preferredNumberOfColumns())
                        
                        
                }
            }
        }
    }
}
