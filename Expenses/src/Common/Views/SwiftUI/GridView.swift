//
//  MonthListView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 16/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI




struct GridView<NC: NavigationCoordinator>: View {
    @ObservedObject var presenter: AbstractEntriesSummaryPresenter
    var columnCount: Int
    var title: String
    var navigationCoordinator: NC
    private var entry: (_ : ExpensesSummarySection, _ : Int, _ : Int, _: Int) -> DisplayExpensesSummaryEntry = { (section, ri, ci, cc) in
        let position = (ri*cc + ci)
        guard (position >= 0) && (position < section.entries.count) else {
            return DisplayExpensesSummaryEntry(id: 0, title: nil, value: nil, signOfAmount: .zero, date: nil, tag: nil)
        }
        return section.entries[position]
    }
    
    init(presenter: AbstractEntriesSummaryPresenter, columnCount: Int, title: String, navigationCoordinator: NC) {
        self.presenter = presenter
        self.columnCount = columnCount
        self.title = title
        self.navigationCoordinator = navigationCoordinator
    }
    
    var body: some View {
        ScrollView {
            ForEach(self.presenter.sections) { section in
                GridViewSectionHeader(section: section)
                GridViewSectionBody(presenter: self.presenter, section: section, navigationCoordinator: self.navigationCoordinator)

            }
        }.navigationBarTitle(self.title)
    }
    
    private func rows(sectionCount: Int, colCount: Int) -> Int {
        return Int(ceil(Double(sectionCount)/Double(colCount)))
    }
}

//struct DayListView_Previews: PreviewProvider {
//    static let entries1 = [DisplayExpensesSummaryEntry(id: 1, title: "", value: "", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 2, title: "", value: "", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 3, title: "", value: "", signOfAmount: .positive, date: "2", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 4, title: "", value: "", signOfAmount: .positive, date: "2", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 5, title: "", value: "", signOfAmount: .positive, date: "2", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 6, title: "", value: "", signOfAmount: .positive, date: "2", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 7, title: "1", value: "1500", signOfAmount: .positive, date: "2", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 8, title: "2", value: "600", signOfAmount: .negative, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 9, title: "3", value: "700", signOfAmount: .negative, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 10, title: "4", value: "800", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 11, title: "5", value: "900", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 12, title: "6", value: "901", signOfAmount: .positive, date: "9", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 13, title: "7", value: "902", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 14, title: "8", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 15, title: "9", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 16, title: "10", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 17, title: "11", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 18, title: "12", value: "903", signOfAmount: .zero, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 19, title: "13", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 20, title: "14", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 21, title: "15", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 22, title: "16", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 23, title: "18", value: "500", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 24, title: "19", value: "600", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 25, title: "20", value: "700", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 26, title: "21", value: "800", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 27, title: "22", value: "900", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 28, title: "23", value: "901", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 29, title: "24", value: "902", signOfAmount: .negative, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 30, title: "25", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 31, title: "26", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 32, title: "27", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 33, title: "28", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 34, title: "29", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 35, title: "30", value: "903", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 36, title: "31", value: "903", signOfAmount: .positive, date: "", tag: nil)]
//            
//    static let section0 = ExpensesSummarySection(id: 0, title: "SEPTEMBER 2019", entries: entries1)
//
//    static let entries2 = [DisplayExpensesSummaryEntry(id: 37, title: "Jan", value: "400", signOfAmount: .negative, date: "1", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 38, title: "Feb", value: "500", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 39, title: "Mar", value: "600", signOfAmount: .negative, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 40, title: "Apr", value: "700", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 41, title: "May", value: "800", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 42, title: "Jun", value: "900", signOfAmount: .positive, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 43, title: "Jul", value: "901", signOfAmount: .zero, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 44, title: "Aug", value: "902", signOfAmount: .zero, date: "", tag: nil),
//                           DisplayExpensesSummaryEntry(id: 45, title: "Sep", value: "903", signOfAmount: .positive, date: "", tag: nil)]
//
//    static let section1 = ExpensesSummarySection(id: 1, title: "2019", entries: entries2)
//    static var previews: some View {
//        Group {
//            GridView(presenter: ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: MockGridDataSource())),
//                     columnCount: 7,
//                     title: "Daily Summary").previewDevice(PreviewDevice(rawValue: "iPhone X")).previewDisplayName("iPhone X")
//
//            GridView(presenter: ShowYearlyEntriesPresenter(interactor: ExpensesSummaryInteractor(dataSource: MockGridDataSource())),
//                     columnCount: 3,
//                     title: "Monthly Summary").previewDevice(PreviewDevice(rawValue: "iPhone SE")).previewDisplayName("iPhone SE")
//        }
//    }
//}
//
//class MockGridDataSource: EntriesSummaryDataSource {
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
