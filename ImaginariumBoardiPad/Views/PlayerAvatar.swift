//
//  PlayerAvatar.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct PlayerAvatar: View {

    let player: Player
    var size: CGFloat = 44
    var showName: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color(hex: player.colorHex))
                    .frame(width: size, height: size)

                Text(player.initial)
                    .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
                    .foregroundStyle(contrastColor)
            }
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )

            if showName {
                Text(player.name)
                    .font(.caption2)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .frame(maxWidth: size + 16)
            }
        }
    }

    private var contrastColor: Color {
        let hex = player.colorHex
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8)  / 255.0
        let b = Double((hex & 0x0000FF))       / 255.0
        return (0.299 * r + 0.587 * g + 0.114 * b) > 0.5 ? .black : .white
    }
}
