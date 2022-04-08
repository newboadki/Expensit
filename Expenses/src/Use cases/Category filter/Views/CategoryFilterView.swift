//
//  CategoryFilterView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 05/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses

struct CategoryFilterView: View {
    
    @ObservedObject var presenter: CategoryFilterPresenter
    @State var isCategoryPickerExpanded: Bool = true
    @Binding var isPresented: Bool
    
    var body: some View {
        CategoryPickerView(isExpanded: true, selectedIndex: $presenter.selectedIndex)
            .environmentObject(presenter)
    }
}
