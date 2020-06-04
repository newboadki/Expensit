//
//  DatePickerView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct DatePickerView: View {
    
    var isExpanded: Bool = false
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date.description).font(.headline)
            
            if isExpanded {
                DatePicker("Date", selection: $date)
            }
        }
    }
}
