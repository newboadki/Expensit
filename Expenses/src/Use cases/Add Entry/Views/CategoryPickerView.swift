//
//  CategoryPickerView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct CategoryPickerView: View {
    
    var isExpanded: Bool = false
    var categories: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        
        let categoryName = (selectedIndex < categories.count) ? categories[selectedIndex] : ""
        
        return VStack(alignment: .leading) {
            Text(categoryName).font(.headline)
            
            if isExpanded {
                Picker(selection: $selectedIndex, label: Text("")) {
                    ForEach(0..<categories.count) {
                        Text($0 < categories.count ? self.categories[$0] : "")
                    }
                }
            }
        }
    }
}
