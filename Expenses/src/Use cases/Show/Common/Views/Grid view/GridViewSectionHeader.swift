//
//  GridViewSection.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct GridViewSectionHeader<NC: GridViewSectionHeaderNavigationCoordinator>: View {
    
    var section: ExpensesSummarySectionViewModel
    var presenter: AbstractEntriesSummaryPresenter
    var navigationCoordinator: NC
    @State private var isNextViewPresented = false
            
    var body: some View {
                
        return HStack {
            Text("\(section.title ?? "-")").bold().padding().font(.system(size: 25)).foregroundColor(.init(red: 255.0/255.0, green: 87.0/255.0, blue: 51.0/255.0))
            Spacer()
            
            Button(action: {
                self.isNextViewPresented.toggle()
            }) {
                Text("Pie Chart")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }.sheet(isPresented: $isNextViewPresented) {
                self.navigationCoordinator.nextView(forIdentifier: "",
                                                    params: (year: self.section.id.year,
                                                             month: self.section.id.month),
                                                           isPresented: self.$isNextViewPresented)
            }
            
        }
    }
}
