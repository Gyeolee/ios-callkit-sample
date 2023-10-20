//
//  IncomingInterfaceView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

struct IncomingInterfaceView: View {
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    
//    let acceptPublishser = NotificationCenter.default
//        .publisher(for: Notification.Name.DidCallAccepted)
    
    var body: some View {
        HStack {
            Button {
                receiveCall(from: "Jaesung Lee", hasVideo: false)
            } label: {
                Image(systemName: "phone.arrow.down.left")
            }
        }
//        .onReceive(self.acceptPublishser) { _ in
//            self.hasActivateCall = true
//            self.providerDelegate?.connectedCall(with: self.callID!)
//        }
    }
    
    func receiveCall(from callerID: String, hasVideo: Bool) {
//        providerDelegate = ProviderDelegate(callManager: callManager)
//        
//        let update = CXCallUpdate()
//        update.remoteHandle = CXHandle(type: .generic, value: callerID)
//        let uuid = UUID()
//        self.callID = uuid
//        
//        self.providerDelegate?.reportIncomingCall(with: uuid, remoteUserID: callerID, hasVideo: hasVideo) { error in
//            if let error = error { print(error.localizedDescription) }
//            else { print("Ring Ring...") }
//        }
    }
}
