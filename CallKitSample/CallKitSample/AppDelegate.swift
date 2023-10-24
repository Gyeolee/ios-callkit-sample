//
//  AppDelegate.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/24/23.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    let callManager: CallManager = .init()
    var providerDelegate: ProviderDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        providerDelegate = ProviderDelegate(callManager: callManager)
        
        return true
    }
}
