//
//  PlayerListView.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct PlayerListView: View {

    @Environment(GameState.self) private var gameState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PLAYERS")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(gameState.players.enumerated()), id: \.element.id) { index, player in
                        playerCard(player, isLeader: index == gameState.currentLeaderIndex % max(gameState.players.count, 1))
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    private func playerCard(_ player: Player, isLeader: Bool) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                PlayerAvatar(player: player, size: 44)

                if isLeader {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.yellow)
                        .offset(x: 6, y: -6)
                }
            }

            Text(player.name)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white)
                .lineLimit(1)

            Text("\(player.position)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: player.colorHex))
        }
        .frame(width: 70)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isLeader ? Color.yellow.opacity(0.5) : Color.white.opacity(0.1),
                            lineWidth: isLeader ? 2 : 1
                        )
                )
        )
    }
}
