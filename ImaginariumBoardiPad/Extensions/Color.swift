//
//  Color.swift
//  ImaginariumBoardiPad
//

import SwiftUI

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        let red   = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8)  / 255.0
        let blue  = Double((hex & 0x0000FF))       / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }

    /// Returns white or black depending on luminance for readable contrast.
    func contrastingTextColor(for hex: UInt) -> Color {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8)  / 255.0
        let b = Double((hex & 0x0000FF))       / 255.0
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.5 ? .black : .white
    }
}
