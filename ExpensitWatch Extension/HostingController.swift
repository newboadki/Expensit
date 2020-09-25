//
//  HostingController.swift
//  ExpensitWatch Extension
//
//  Created by Borja Arias Drake on 15/08/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import WatchConnectivity

class HostingController: WKHostingController<ContentView>, WCSessionDelegate {
    
    private var session: WCSession?
    
    override var body: ContentView {
        return ContentView(session: session)
    }
    
    // MARK: - Initializers
    
    override init() {
        super.init()

        if WCSession.isSupported() {
            session = WCSession.default
            session!.delegate = self
            session!.activate()
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
