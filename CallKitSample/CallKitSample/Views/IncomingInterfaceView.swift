//
//  IncomingInterfaceView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI
import CallKit

struct IncomingInterfaceView: View {
    @EnvironmentObject var callManager: CallManager
    
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    
    @State private var providerDelegate: ProviderDelegate?
    
    private let acceptPublishser = NotificationCenter.default
        .publisher(for: Notification.Name.DidCallAccepted)
    
    var body: some View {
        Button {
            receiveCall(from: "Hangyeol Lee", hasVideo: false)
        } label: {
            Image(systemName: "phone.arrow.down.left")
        }
        .onReceive(acceptPublishser) { _ in
            hasActivateCall = true
            providerDelegate?.connectedCall(with: callID!)
        }
    }
    
    func receiveCall(from callerID: String, hasVideo: Bool) {
        providerDelegate = ProviderDelegate(callManager: callManager)
        
        let uuid = UUID()
        callID = uuid
        
        Task {
            do {
                try await providerDelegate?.reportIncomingCall(with: uuid, remoteUserID: callerID, hasVideo: hasVideo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
