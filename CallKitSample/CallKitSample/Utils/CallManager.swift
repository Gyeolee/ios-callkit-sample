//
//  CallManager.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import CallKit

final class CallManager: NSObject, ObservableObject {
    private let provider = CXProvider(configuration: CXProviderConfiguration())
    private let callController = CXCallController()
    
    private(set) var callIDs: [UUID] = []
    
    override init() {
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
    
    func start(with uuid: UUID, receiverID: String, hasVideo: Bool) async throws {
        let handler = CXHandle(type: .generic, value: receiverID)
        
        let startCallAction = CXStartCallAction(call: uuid, handle: handler)
        startCallAction.isVideo = hasVideo
        
        let transaction = CXTransaction(action: startCallAction)
        try await requestTransaction(transaction)
    }
    
    func end(with uuid: UUID) async throws {
        let endCallAction = CXEndCallAction(call: uuid)
        
        let transaction = CXTransaction(action: endCallAction)
        try await requestTransaction(transaction)
    }
    
    func mute(with uuid: UUID, muted: Bool) async throws {
        let mutedCallAction = CXSetMutedCallAction(call: uuid, muted: muted)
        
        let transaction = CXTransaction(action: mutedCallAction)
        try await requestTransaction(transaction)
    }
}

extension CallManager {
    func reportIncoming(with uuid: UUID, remoteUserID: String, hasVideo: Bool) async throws {
        let callUpdate = CXCallUpdate()
        callUpdate.update(with: remoteUserID, hasVideo: hasVideo)
        
        try await provider.reportNewIncomingCall(with: uuid, update: callUpdate)
        addCall(uuid: uuid)
    }
    
    func connectedCall(with uuid: UUID) {
        provider.reportOutgoingCall(with: uuid, connectedAt: Date())
    }
}

extension CallManager {
    private func requestTransaction(_ transaction: CXTransaction) async throws {
        try await callController.request(transaction)
    }
}

extension CallManager {
    func addCall(uuid: UUID) {
        callIDs.append(uuid)
    }
    
    func removeCall(uuid: UUID) {
        callIDs.removeAll { $0 == uuid }
    }
    
    func removeAllCalls() {
        callIDs.removeAll()
    }
}

// MARK: - CXProviderDelegate

extension CallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        removeAllCalls()
    }
    
    // 걸기
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        addCall(uuid: action.callUUID)
        connectedCall(with: action.callUUID)
        
        action.fulfill()
    }
    
    // 끊기
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NotificationCenter.default.post(name: NSNotification.Name.DidCallEnd, object: nil)
        
        action.fulfill()
        
        removeAllCalls()
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
