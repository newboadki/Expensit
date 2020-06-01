//
//  GridViewSectionBodyRow.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct GridViewSectionBodyRow <NC: NavigationCoordinator>: View {
    
    var section: ExpensesSummarySectionViewModel
    var rowIndex: Int
    var navigationCoordinator: NC
    var numberOfColumns: Int
    var preferredNumberOfColumns: Int
    
    
    var body: some View {
        ForEach(0..<preferredNumberOfColumns, id:\.self) { columnIndex in
            HStack {
                if self.numberOfColumns < self.preferredNumberOfColumns {
                    if columnIndex < self.preferredNumberOfColumns {
                        GridViewSectionBodyRowNavCell(section: self.section, rowIndex: self.rowIndex, columnIndex: columnIndex, navigationCoordinator: self.navigationCoordinator, numberOfColumns: self.numberOfColumns, preferredNumberOfColumns: self.preferredNumberOfColumns)
                    } else {
                        EntryBoxView(title: "", amount: "", sign: .zero)
                    }
                } else {
                    GridViewSectionBodyRowNavCell(section: self.section, rowIndex: self.rowIndex, columnIndex: columnIndex, navigationCoordinator: self.navigationCoordinator, numberOfColumns: self.numberOfColumns, preferredNumberOfColumns: self.preferredNumberOfColumns)
                }
            }
        }
    }
}
