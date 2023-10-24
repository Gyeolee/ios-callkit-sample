//
//  CallManager.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import CallKit

final class CallManager: ObservableObject {
    private let callController = CXCallController()
    private(set) var callIDs: [UUID] = []
    
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
