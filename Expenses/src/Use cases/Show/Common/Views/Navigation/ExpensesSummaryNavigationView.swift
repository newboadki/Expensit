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
        NavigationView {
            self.navigationCoordinator.nextView(forIdentifier: "")
        }
    }
}
