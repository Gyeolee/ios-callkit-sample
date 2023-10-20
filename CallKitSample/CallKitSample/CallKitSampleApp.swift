//
//  CallKitSampleApp.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

@main
struct CallKitSampleApp: App {
    let callManager = CallManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(callManager)
        }
    }
}
