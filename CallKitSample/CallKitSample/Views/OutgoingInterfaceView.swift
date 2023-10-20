//
//  OutgoingInterfaceView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

struct OutgoingInterfaceView: View {
    @EnvironmentObject var callManager: CallManager
    
    @Binding var receiverID: String
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    
    var body: some View {
        Button {
            startCall(to: self.$receiverID.wrappedValue, hasVideo: false)
        } label: {
            Image(systemName: "phone.fill.arrow.up.right")
        }
    }
    
    func startCall(to receiverID: String, hasVideo: Bool) {
        let uuid = UUID()
        callID = uuid
        
        Task {
            do {
                try await callManager.start(with: uuid, receiverID: receiverID, hasVideo: hasVideo)
                print("전화 걸기")
                hasActivateCall = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
