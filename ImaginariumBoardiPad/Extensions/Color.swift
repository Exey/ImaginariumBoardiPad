//
//  Color.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 30.05.2022.
//

import SwiftUI

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
