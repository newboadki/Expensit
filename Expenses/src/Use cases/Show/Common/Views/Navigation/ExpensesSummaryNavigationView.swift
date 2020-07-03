//
//  ExpensesSummaryNavigationView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 27/04/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI


struct ExpensesSummaryNavigationView<NC: NavigationCoordinator>: View {

    var navigationCoordinator: NC
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                NavigationView {
                    self.navigationCoordinator.nextView(forIdentifier: nil)
                    //Text("This is an ipad!")
                }.navigationViewStyle(StackNavigationViewStyle())
                    .frame(width: self.navigationWidth(geometry: geometry), height: nil, alignment: .topLeading)
                    
                
                Spacer()
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text("This is an ipad!")
                }
                Spacer()

            }
            .accentColor(Color(#colorLiteral(red: 0, green: 0.7931181788, blue: 0.6052855253, alpha: 1)))
        }
    }
    
    private func navigationWidth(geometry: GeometryProxy) -> CGFloat {
        (UIDevice.current.userInterfaceIdiom == .pad) ? (geometry.size.width / 3) : geometry.size.width
    }
}
