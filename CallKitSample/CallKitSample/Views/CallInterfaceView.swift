//
//  CallInterfaceView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

struct CallInterfaceView: View {
    @EnvironmentObject var callManager: CallManager
    
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    
    @State private var isMuted: Bool = false
    
    var body: some View {
        HStack {
            Button(action: muteAudio) {
                Image(systemName: isMuted ? "mic.fill" : "mic.slash.fill")
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 24)
            
            Button(action: endCall) {
                Image(systemName: "phone.down.fill")
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 24)
        }
    }
    
    func muteAudio() {
        isMuted.toggle()
        
        guard let callID else {
            return
        }
        
        Task {
            do {
                try await callManager.mute(with: callID, muted: isMuted)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func endCall() {
        guard let callID else {
            return
        }
        
        Task {
            do {
                try await callManager.end(with: callID)
                hasActivateCall = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
