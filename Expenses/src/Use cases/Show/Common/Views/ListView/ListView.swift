//
//  YearlyListView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/11/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses





struct ListView<NC: NavigationCoordinator> : View {
    
    // MARK: Private Properties
    
    @ObservedObject private var presenter: AbstractAppPresenter
    private var navigationButtonsPresenter: NavigationButtonsPresenter
    private var title: String
    private var navigationCoordinator: NC
    private var entryFormCoordinator: ExpensesEntryFormNavigationCoordinator
    private var categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator
    private var targetDestination: DateComponents?
    
    // MARK: Initializers
    
    init(presenter:AbstractAppPresenter,
         navigationButtonsPresenter: NavigationButtonsPresenter,
         title: String,
         navigationCoordinator: NC,
         entryFormCoordinator: ExpensesEntryFormNavigationCoordinator,
         categoryFilterNavgationCoordinator: CategoryFilterNavigationCoordinator,
         targetDestination: DateComponents? = nil) {
        self.presenter = presenter
        self.title = title
        self.navigationCoordinator = navigationCoordinator
        self.entryFormCoordinator = entryFormCoordinator
        self.categoryFilterNavgationCoordinator = categoryFilterNavgationCoordinator
        self.navigationButtonsPresenter = navigationButtonsPresenter
        self.targetDestination = targetDestination
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack {
                    ForEach(self.presenter.sections) { section in
                        VStack {
                            HStack {
                                Text(section.title ?? "-").bold().padding().font(.system(size: 25)).foregroundColor(.init(red: 255.0/255.0, green: 87.0/255.0, blue: 51.0/255.0))
                                Spacer()
                            }
                            
                            ForEach(section.entries) { entry in
                                NavigationLink(destination: LazyView(self.navigationCoordinator.nextView(forIdentifier: entry.id))) {
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
            .onAppear(perform: {
                self.presenter.bind()
                if let destination = self.targetDestination {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        withAnimation() {
                            scrollView.scrollTo(destination)
                        }

                    }
                }
            })
            .onDisappear(perform: {
                self.presenter.unbind()
            })
        }

    }
}
