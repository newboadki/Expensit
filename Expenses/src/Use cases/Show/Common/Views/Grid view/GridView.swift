//
//  MonthListView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses

struct GridView<NC: NavigationCoordinator,
                HeaderNavCoordinator: GridViewSectionHeaderNavigationCoordinator>: View {
    
    @ObservedObject private var presenter: AbstractEntriesSummaryPresenter
    private var navigationButtonsPresenter: NavigationButtonsPresenter
    @State private var showEntryForm = false
    private var columnCount: Int
    private var title: String
    private var navigationCoordinator: NC
    private var entryFormCoordinator: EntryFormNavigationCoordinator
    private var categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator
    private var headerViewNavigationCoordinator: HeaderNavCoordinator
    
    private var entry: (_ : ExpensesSummarySectionViewModel, _ : Int, _ : Int, _: Int) -> ExpensesSummaryEntryViewModel = { (section, ri, ci, cc) in
        let position = (ri*cc + ci)
        guard (position >= 0) && (position < section.entries.count) else {
            return ExpensesSummaryEntryViewModel(id: DateComponents(), title: nil, value: nil, signOfAmount: .zero, date: nil, tag: nil)
        }
        return section.entries[position]
    }
    
    init(presenter: AbstractEntriesSummaryPresenter,
         columnCount: Int,
         title: String,
         navigationButtonsPresenter: NavigationButtonsPresenter,
         navigationCoordinator: NC,
         entryFormCoordinator: EntryFormNavigationCoordinator,
         categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator,
         headerViewNavigationCoordinator: HeaderNavCoordinator) {
        self.presenter = presenter
        self.navigationButtonsPresenter = navigationButtonsPresenter
        self.columnCount = columnCount
        self.title = title
        self.navigationCoordinator = navigationCoordinator
        self.entryFormCoordinator = entryFormCoordinator
        self.categoryFilterNavgationCoordinator = categoryFilterNavgationCoordinator
        self.headerViewNavigationCoordinator = headerViewNavigationCoordinator
    }
    
    var body: some View {
        ScrollView {
            ForEach(self.presenter.sections) { section in
                
                GridViewSectionHeader(section: section, presenter: self.presenter,
                                      navigationCoordinator: self.headerViewNavigationCoordinator)
                
                GridViewSectionBody(presenter: self.presenter,
                                    section: section,
                                    navigationCoordinator: self.navigationCoordinator)

            }
        }.navigationBarTitle(self.title)
         .navigationBarItems(trailing:
             NavigationButtonsView(entryFormCoordinator: self.entryFormCoordinator,
                                   categoryFilterNavgationCoordinator: self.categoryFilterNavgationCoordinator,
                                   presenter: navigationButtonsPresenter)
         )
    }
    
    private func rows(sectionCount: Int, colCount: Int) -> Int {
        return Int(ceil(Double(sectionCount)/Double(colCount)))
    }
}
