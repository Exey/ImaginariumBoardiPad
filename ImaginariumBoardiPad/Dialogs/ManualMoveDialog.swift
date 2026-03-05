//
//  ManualMoveDialog.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct ManualMoveDialog: View {

    @Environment(GameState.self) private var gameState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    Text("Tap + or − to adjust positions manually.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 8)

                    ForEach(gameState.players) { player in
                        HStack(spacing: 12) {
                            PlayerAvatar(player: player, size: 36)

                            Text(player.name)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white)
                                .lineLimit(1)

                            Spacer()

                            HStack(spacing: 10) {
                                Button {
                                    gameState.movePlayer(id: player.id, by: -1)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.orange)
                                }
                                .disabled(player.position <= 0)

                                Text("\(player.position)")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .frame(width: 40)

                                Button {
                                    gameState.movePlayer(id: player.id, by: 1)
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                        .padding(10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
            }
            .navigationTitle("Manual Move")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
