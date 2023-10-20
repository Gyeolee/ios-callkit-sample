//
//  CXCallUpdate+Extension.swift
//  CallKitSample
//
//  Created by Hangyeol on 10/20/23.
//

import CallKit

extension CXCallUpdate {
    func update(with remoteUserID: String, hasVideo: Bool) {
        let remoteHandler = CXHandle(type: .generic, value: remoteUserID)
        
        self.remoteHandle = remoteHandler
        self.localizedCallerName = remoteUserID
        self.hasVideo = hasVideo
    }
    
    func onFailed(with uuid: UUID) {
        let remoteHandler = CXHandle(type: .generic, value: "Unknown")
        
        self.remoteHandle = remoteHandler
        self.localizedCallerName = "Unknown"
        self.hasVideo = false
    }
}
