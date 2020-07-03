//
//  YearlyListView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/11/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct ListView<NC: NavigationCoordinator> : View {
    
    // MARK: Private Properties
    
    @ObservedObject private var presenter: AbstractEntriesSummaryPresenter
    private var navigationButtonsPresenter: NavigationButtonsPresenter
    private var title: String
    private var navigationCoordinator: NC
    private var entryFormCoordinator: EntryFormNavigationCoordinator
    private var categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator
    
    // MARK: Initializers
    
    init(presenter:AbstractEntriesSummaryPresenter,
         navigationButtonsPresenter: NavigationButtonsPresenter,
         title: String,
         navigationCoordinator: NC,
         entryFormCoordinator: EntryFormNavigationCoordinator,
         categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator) {
        self.presenter = presenter
        self.title = title
        self.navigationCoordinator = navigationCoordinator
        self.entryFormCoordinator = entryFormCoordinator
        self.categoryFilterNavgationCoordinator = categoryFilterNavgationCoordinator
        self.navigationButtonsPresenter = navigationButtonsPresenter
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.presenter.sections) { section in
                    VStack {
                        HStack {
                            Text(section.title ?? "-").bold().padding().font(.system(size: 25)).foregroundColor(.init(red: 255.0/255.0, green: 87.0/255.0, blue: 51.0/255.0))
                            Spacer()
                        }
                        
                        ForEach(section.entries) { entry in
                            
                            NavigationLink(destination: self.navigationCoordinator.nextView(forIdentifier: entry.id)) {
                               HorizontalEntryView(title: entry.title ?? "-", amount: entry.value ?? "-", desc: "", sign: entry.signOfAmount).padding(10)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }.navigationBarTitle(Text(self.presenter.title), displayMode: .inline)
             .navigationBarItems(trailing:
                NavigationButtonsView(entryFormCoordinator: self.entryFormCoordinator,
                                      categoryFilterNavgationCoordinator: self.categoryFilterNavgationCoordinator,
                                      presenter: navigationButtonsPresenter)
            )
        }
    }
}

//struct YearlyListView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        // presenter: ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: MockListDataSource())),
//        ListView(presenter: ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: MockListDataSource())),
//                 title: "Yearly Summary")
//    }
//}
//
//class MockListDataSource: EntriesSummaryDataSource {
//    @Published var groupedExpenses = [ExpensesGroup]()
//    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
//    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
//    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>    
//    
//    init() {
//        self.fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
//        self.groupedExpenses = [ExpensesGroup]()
//        self.groupedExpenses.append(ExpensesGroup(key: "2019",
//                                                  entries: [Expense(date: Date(), value: 27, description: nil, category: nil),
//                                                            Expense(date: Date(), value: 5, description: nil, category: nil)]))
//    }
//}
