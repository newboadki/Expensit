//
//  GridViewSectionBodyRowNavCell.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses

struct GridViewSectionBodyRowNavCell<NC:NavigationCoordinator>: View {
        
    var section: ExpensesSummarySectionViewModel
    var rowIndex: Int
    var columnIndex: Int
    var navigationCoordinator: NC
    var numberOfColumns: Int
    var preferredNumberOfColumns: Int

    init(section: ExpensesSummarySectionViewModel, rowIndex: Int,
         columnIndex: Int, navigationCoordinator: NC, numberOfColumns: Int, preferredNumberOfColumns: Int) {
        
        self.navigationCoordinator = navigationCoordinator
        self.rowIndex = rowIndex
        self.columnIndex = columnIndex
        self.section = section
        self.numberOfColumns = numberOfColumns
        self.preferredNumberOfColumns = preferredNumberOfColumns
    }
    
    var body: some View {
        NavigationLink(destination: self.navigationCoordinator.nextView(forIdentifier: (self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).id))) {
            EntryBoxView(title: "\(self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).title ?? "")",
                        amount: "\(self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).value ?? "")",
                        sign: self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).signOfAmount)
        }.buttonStyle(PlainButtonStyle())

    }
    
    private var entry: (_ : ExpensesSummarySectionViewModel, _ : Int, _ : Int, _: Int) -> ExpensesSummaryEntryViewModel = { (section, ri, ci, cc) in
        let position = (ri*cc + ci)
        guard (position >= 0) && (position < section.entries.count) else {
            return ExpensesSummaryEntryViewModel(id: DateComponents(), title: nil, value: nil, signOfAmount: .zero, date: nil, tag: nil, currencyCode: "")
        }
        return section.entries[position]
    }

}
