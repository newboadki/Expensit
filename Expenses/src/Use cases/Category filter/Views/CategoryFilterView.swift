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
        CategoryPickerView(isExpanded: true,
                           categories: presenter.categoryNames,
                           selectedIndex: categoryBinding())

    }
    
    private func categoryBinding() -> Binding<Int> {
        return Binding<Int>(
            get: {
                self.presenter.selectedIndex
            },
            set: {
                self.presenter.selectedIndex = $0
            }
        )
    }

}
