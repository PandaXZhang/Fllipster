//
//  FllipsterApp.swift
//  Fllipster
//
//  Created by spantar on 2025/6/4.
//

import SwiftUI

@main
struct FllipsterApp: App {
    @Environment(\.scenePhase) var scenePhase
    
//    init() {
//        WebSocketManager.shared.connect()
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .active:
                        WebSocketManager.shared.connect()
                    case .inactive, .background:
                        WebSocketManager.shared.disconnect()
                    @unknown default:
                        break
                    }
                }
        }
    }
}
