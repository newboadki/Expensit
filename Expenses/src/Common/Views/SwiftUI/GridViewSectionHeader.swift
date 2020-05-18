//
//  GridViewSection.swift
//  Expensit
//
//  Created by Borja Arias Drake on 03/05/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct GridViewSectionHeader: View {
    
    var section: ExpensesSummarySection
            
    var body: some View {
        HStack {
            Text("\(section.title ?? "-")").bold().padding().font(.system(size: 25)).foregroundColor(.init(red: 255.0/255.0, green: 87.0/255.0, blue: 51.0/255.0))
            Spacer()
        }
    }
}
