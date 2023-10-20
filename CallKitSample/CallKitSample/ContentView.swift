//
//  ContentView.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var callManager: CallManager
    
    @State var hasActivateCall: Bool = false
    @State var callID: UUID? = nil
    @State var receiverID: String = "+821071674879"
    
    private var color: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        VStack {
            Text("CallKit + SwiftUI")
                .font(.title)
                .bold()
                .padding(.vertical, 112)
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                
                TextField("Receiver ID", text: self.$receiverID)
                    .font(.body)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
            
            if self.hasActivateCall {
                Color(color)
                    .frame(width: 176, height: 64)
                    .cornerRadius(32)
                    .overlay(CallInterfaceView(hasActivateCall: self.$hasActivateCall, callID: self.$callID))
                
            } else {
                HStack {
                    Color(color)
                        .frame(width: 64, height: 64)
                        .cornerRadius(32)
                        .overlay(
                            OutgoingInterfaceView(receiverID: $receiverID, hasActivateCall: $hasActivateCall, callID: $callID)
                                .foregroundColor(.green)
                        )
                        .padding(.horizontal, 24)
                    
                    Color(color)
                        .frame(width: 64, height: 64)
                        .cornerRadius(32)
                        .overlay(
                            IncomingInterfaceView(hasActivateCall: $hasActivateCall, callID: $callID)
                                .foregroundColor(.blue)
                        )
                        .padding(.horizontal, 24)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
