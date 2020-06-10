//
//  EntryBoxView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 01/11/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct EntryBoxView: View {
    var title: String
    var amount: String
    var sign: BSNumberSignType
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(title).bold()
                Spacer()
            }
            Spacer()
            if !amount.isEmpty {
                VStack {
                    Text(amount)
                        .font(.system(size: 10))
                        .padding(.all, 2)
                        .background(self.color(for: sign))
                        .cornerRadius(5)
                }
            }
            Spacer()

        }.frame(width: nil, height: 70, alignment: .center)
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

struct EntryBoxView_Previews: PreviewProvider {
    static var previews: some View {
        EntryBoxView(title: "MAY", amount: "100.0€", sign: .positive)
    }
}
