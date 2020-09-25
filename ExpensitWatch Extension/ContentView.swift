//
//  ContentView.swift
//  ExpensitWatch Extension
//
//  Created by Borja Arias Drake on 15/08/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    private var session: WCSession?
    
    init(session: WCSession?) {
        self.session = session
    }
    
    var body: some View {
        VStack {
            Button(action: {
                print("Button pressed!")
                self.session?.sendMessage(["a" : "a"], replyHandler: { responseDict in
                    print("Response")
                }, errorHandler: { error in
                    print("Error")
                })
            }) {
                Text("Button")
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
