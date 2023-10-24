//
//  ProviderDelegate.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/24/23.
//

import UIKit
import CallKit

extension CXProvider {
    static var custom: CXProvider {
        let configuration = CXProviderConfiguration()
        configuration.supportsVideo = true
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportedHandleTypes = [.generic]
        if let iconImage = UIImage(named: "App Icon") {
            configuration.iconTemplateImageData = iconImage.pngData()
        }
        configuration.ringtoneSound = "Rington.caf"
        
        let provider = CXProvider(configuration: configuration)
        return provider
    }
}

final class ProviderDelegate: NSObject {
    private let callManager: CallManager
    private let provider: CXProvider = .custom
    
    init(callManager: CallManager) {
        self.callManager = callManager
        
        super.init()
        
        // if queue value is nil, delegate will run on main thread
        provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(with uuid: UUID, remoteUserID: String, hasVideo: Bool) async throws {
        let callUpdate = CXCallUpdate()
        callUpdate.update(with: remoteUserID, hasVideo: hasVideo)
        
        try await provider.reportNewIncomingCall(with: uuid, update: callUpdate)
        callManager.addCall(uuid: uuid)
    }
    
    func reportIncomingCall(with uuid: UUID) async throws {
        let update = CXCallUpdate()
        update.onFailed(with: uuid)
        
        try await provider.reportNewIncomingCall(with: uuid, update: update)
        provider.reportCall(with: uuid, endedAt: Date(), reason: .failed)
    }
    
    func endCall(with uuid: UUID, endedAt: Date, reason: CXCallEndedReason) {
        provider.reportCall(with: uuid, endedAt: endedAt, reason: reason)
    }
    
    func connectedCall(with uuid: UUID) {
        provider.reportOutgoingCall(with: uuid, connectedAt: Date())
    }
}

extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        callManager.removeAllCalls()
    }
    
    // 걸기
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        callManager.addCall(uuid: action.callUUID)
        connectedCall(with: action.callUUID)
        
        action.fulfill()
    }
    
    // 끊기
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NotificationCenter.default.post(name: NSNotification.Name.DidCallEnd, object: nil)
        
        action.fulfill()
        
        callManager.removeAllCalls()
    }
    
    // 받기
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        NotificationCenter.default.post(name: NSNotification.Name.DidCallAccepted, object: nil)
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        if action.isOnHold {
            action.fulfill()
            return
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        action.fulfill()
    }
}
