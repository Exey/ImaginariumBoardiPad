//
//  BoardView.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct BoardView: View {

    @Environment(GameState.self) private var gameState

    var body: some View {
        VStack(spacing: 6) {
            ForEach(Array(gameState.boardGrid.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 6) {
                    ForEach(row) { tile in
                        TileCell(tile: tile)
                    }
                    // Fill remaining space if row has < 4 items (last row)
                    if row.count < 4 {
                        ForEach(0..<(4 - row.count), id: \.self) { _ in
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 90)
                        }
                    }
                }
            }
        }
    }
}

struct TileCell: View {

    @Environment(GameState.self) private var gameState
    let tile: Tile

    private var playersHere: [Player] {
        gameState.playersOnTile(tile.index)
    }

    private var isStart: Bool { tile.index == 0 }
    private var isFinish: Bool { tile.index == 39 }

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(borderColor, lineWidth: borderWidth)
                )

            VStack(spacing: 2) {
                // Top row: index + special icon
                HStack(spacing: 4) {
                    Text("\(tile.index)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(tile.type == .empty ? .white.opacity(0.7) : tile.type.color)

                    if tile.type != .empty {
                        Image(systemName: tile.type.icon)
                            .font(.system(size: 12))
                            .foregroundStyle(tile.type.color)
                    }

                    Spacer()

                    if isFinish {
                        Image(systemName: "flag.checkered")
                            .font(.system(size: 14))
                            .foregroundStyle(.yellow)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 6)

                // Player tokens
                if playersHere.isEmpty {
                    Spacer()
                } else {
                    playerTokens
                        .padding(.horizontal, 4)
                    Spacer(minLength: 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
    }

    private var borderColor: Color {
        if !playersHere.isEmpty {
            return .white.opacity(0.3)
        }
        if tile.type != .empty {
            return tile.type.color.opacity(0.3)
        }
        return .white.opacity(0.08)
    }

    private var borderWidth: CGFloat {
        !playersHere.isEmpty ? 1.5 : 1
    }

    private var playerTokens: some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 2),
            count: min(playersHere.count, 4)
        )
        return LazyVGrid(columns: columns, spacing: 2) {
            ForEach(playersHere) { player in
                Circle()
                    .fill(Color(hex: player.colorHex))
                    .frame(width: tokenSize, height: tokenSize)
                    .overlay(
                        Text(player.initial)
                            .font(.system(size: tokenSize * 0.5, weight: .bold, design: .rounded))
                            .foregroundStyle(contrastColor(for: player.colorHex))
                    )
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.4), lineWidth: 0.5)
                    )
            }
        }
    }

    private var tokenSize: CGFloat {
        switch playersHere.count {
        case 1...4:  return 22
        case 5...8:  return 18
        case 9...12: return 15
        default:     return 12
        }
    }

    private func contrastColor(for hex: UInt) -> Color {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8)  / 255.0
        let b = Double((hex & 0x0000FF))       / 255.0
        return (0.299 * r + 0.587 * g + 0.114 * b) > 0.5 ? .black : .white
    }
}
