//
//  OutgoingInterfaceView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

struct OutgoingInterfaceView: View {
    @Binding var receiverID: String
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    
    var body: some View {
        HStack {
            // MARK: Voice Call
            Button {
                startCall(to: self.$receiverID.wrappedValue, hasVideo: false)
            } label: {
                Image(systemName: "phone.fill.arrow.up.right")
            }
        }
    }
    
    func startCall(to receiverID: String, hasVideo: Bool) {
        let uuid = UUID()
        callID = uuid
        
//        self.callManager.startCall(with: uuid, receiverID: receiverID, hasVideo: hasVideo) { error in
//            if let error = error { print(error.localizedDescription) }
//            else { self.hasActivateCall = true }
//        }
    }
}
