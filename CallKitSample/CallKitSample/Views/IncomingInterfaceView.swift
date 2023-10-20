//
//  IncomingInterfaceView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

struct IncomingInterfaceView: View {
    @EnvironmentObject var callManager: CallManager
    
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    
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
            callManager.connectedCall(with: callID!)
        }
    }
    
    func receiveCall(from callerID: String, hasVideo: Bool) {
        let uuid = UUID()
        callID = uuid
        
        Task {
            do {
                try await callManager.reportIncoming(with: uuid, remoteUserID: callerID, hasVideo: hasVideo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
