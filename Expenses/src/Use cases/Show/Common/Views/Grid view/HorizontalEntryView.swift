//
//  YearView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 02/11/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI


struct HorizontalEntryView: View {
    var title: String
    var amount: String
    var desc: String
    var sign: BSNumberSignType
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if !title.isEmpty {
                    Text(title).bold()
                }
                if !desc.isEmpty {
                    Text(desc).font(.subheadline)
                }
            }
            

            Spacer()
            
            Text(amount)
                .font(.system(size: 12))
                .padding(5)
                .background(self.color(for: sign))
                .cornerRadius(5)
        }.frame(width: nil, height: 30, alignment: .center)            
    }
    
    private func color(for sign: BSNumberSignType) -> Color {
        switch sign {
        case .positive:
            return Color.green.opacity(0.3)
        case .negative:
            return Color.red.opacity(0.3)
        case .zero:
            return Color.blue.opacity(0.3)
        }
    }
}

struct YearView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalEntryView(title: "1983", amount: "100,000.0€", desc: "",  sign: .positive)
    }
}
