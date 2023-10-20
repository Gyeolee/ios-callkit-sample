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
}

extension CallManager {
    private func requestTransaction(_ transaction: CXTransaction) async throws {
        try await callController.request(transaction)
    }
}

// MARK: - CXProviderDelegate

extension CallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("providerDidReset: \(provider)")
    }
    
    // 전화 걸기
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    // 전화 받기
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
}
