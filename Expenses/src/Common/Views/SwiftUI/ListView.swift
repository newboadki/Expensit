//
//  YearlyListView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/11/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct ListView<NC: NavigationCoordinator> : View {
    @ObservedObject var presenter: AbstractEntriesSummaryPresenter    
    var title: String
    var navigationCoordinator: NC
    
    init(presenter:AbstractEntriesSummaryPresenter,
         title: String,
         navigationCoordinator: NC) {
        self.presenter = presenter
        self.title = title
        self.navigationCoordinator = navigationCoordinator
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
                            NavigationLink(destination: self.navigationCoordinator.nextView(forIdentifier: entry.title ?? "")) {
                               HorizontalEntryView(title: entry.title ?? "-", amount: entry.value ?? "-", desc: "", sign: entry.signOfAmount).padding(10)
                            }.buttonStyle(PlainButtonStyle())
                        }

                    }
                }
            }.navigationBarTitle(self.presenter.title)
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
class MockListDataSource: EntriesSummaryDataSource {
    @Published var groupedExpenses = [ExpensesGroup]()
    var groupedExpensesPublished : Published<[ExpensesGroup]> {_groupedExpenses}
    var groupedExpensesPublisher : Published<[ExpensesGroup]>.Publisher {$groupedExpenses}
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>    
    
    init() {
        self.fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
        self.groupedExpenses = [ExpensesGroup]()
        self.groupedExpenses.append(ExpensesGroup(key: "2019",
                                                  entries: [Expense(date: Date(), value: 27, description: nil, category: nil),
                                                            Expense(date: Date(), value: 5, description: nil, category: nil)]))
    }
}