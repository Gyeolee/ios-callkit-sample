//
//  CallKitSampleApp.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

@main
struct CallKitSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let callManager: CallManager = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(callManager)
        }
    }
}
