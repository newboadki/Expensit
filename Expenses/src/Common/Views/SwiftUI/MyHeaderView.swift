//
//  MyHeaderView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 27/10/2019.
//  Copyright © 2019 Borja Arias Drake. All rights reserved.
//

import SwiftUI

struct MyHeaderView: View {
    var text: String
    
    var body: some View {
        Text(self.text).background(Color(.white))
    }
}

struct MyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MyHeaderView(text: "Section Name")
    }
}
