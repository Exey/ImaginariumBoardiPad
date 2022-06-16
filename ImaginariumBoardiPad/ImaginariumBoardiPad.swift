//
//  ImaginariumBoardiPadApp.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 30.05.2022.
//

import SwiftUI

@main
struct ImaginariumBoardiPadApp: App {
    var body: some Scene {
        WindowGroup {
            Root()
                .environmentObject(TilesViewModel())
                .environmentObject(ImaginariumState())
        }
    }
}
