//
//  GridViewSectionBodyRowNavCell.swift
//  Expensit
//
//  Created by Borja Arias Drake on 18/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct GridViewSectionBodyRowNavCell<NC:NavigationCoordinator>: View {
    
    //@ObservedObject var presenter: AbstractEntriesSummaryPresenter
    var section: ExpensesSummarySection
    var rowIndex: Int
    var columnIndex: Int
    var navigationCoordinator: NC
    var numberOfColumns: Int
    var preferredNumberOfColumns: Int

    init(section: ExpensesSummarySection, rowIndex: Int,
         columnIndex: Int, navigationCoordinator: NC, numberOfColumns: Int, preferredNumberOfColumns: Int) {
        
        self.navigationCoordinator = navigationCoordinator
        self.rowIndex = rowIndex
        self.columnIndex = columnIndex
        self.section = section
        self.numberOfColumns = numberOfColumns
        self.preferredNumberOfColumns = preferredNumberOfColumns
    }
    
    var body: some View {
        NavigationLink(destination: self.navigationCoordinator.nextView(forIdentifier: self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).title ?? "")) {
            EntryBoxView(title: "\(self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).title ?? "")",
                        amount: "\(self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).value ?? "")",
                        sign: self.entry(self.section, self.rowIndex, columnIndex, self.preferredNumberOfColumns).signOfAmount)
        }.buttonStyle(PlainButtonStyle())

    }
    
    private var entry: (_ : ExpensesSummarySection, _ : Int, _ : Int, _: Int) -> DisplayExpensesSummaryEntry = { (section, ri, ci, cc) in
        let position = (ri*cc + ci)
        guard (position >= 0) && (position < section.entries.count) else {
            return DisplayExpensesSummaryEntry(id: 0, title: nil, value: nil, signOfAmount: .zero, date: nil, tag: nil)
        }
        return section.entries[position]
    }

}
