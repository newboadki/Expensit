//
//  CategoryPickerView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import CoreExpenses

struct CategoryPickerView: View {
    
    var isExpanded: Bool = false
    @EnvironmentObject var presenter: CategoryFilterPresenter
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Select a category to filter by").font(.headline)
                .padding(.top, 50)
            
            Spacer()
            
            Picker(selection: $selectedIndex, label: Text("")) {
                ForEach(presenter.enumeratedCategories) { category in
                    Text(category.name).tag(category.id)
                }
            }
            .pickerStyle(.wheel)
        }
    }
}
