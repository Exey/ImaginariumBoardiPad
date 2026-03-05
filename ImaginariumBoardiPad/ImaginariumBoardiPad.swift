//
//  ImaginariumBoardiPadApp.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 30.05.2022.
//  Updated to Swift 6 / SwiftUI @Observable — 2026.
//

import SwiftUI

@main
struct ImaginariumBoardiPadApp: App {

    @State private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            Root()
                .environment(gameState)
                .preferredColorScheme(.dark)
        }
    }
}
