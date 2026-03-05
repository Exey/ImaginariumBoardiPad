//
//  SettingsDialog.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct SettingsDialog: View {

    @Environment(GameState.self) private var gameState
    @Environment(\.dismiss) private var dismiss

    @State private var showResetConfirm = false
    @State private var showRemoveAllConfirm = false

    var body: some View {
        @Bindable var gs = gameState

        NavigationStack {
            List {
                Section("Game") {
                    Toggle("Allow play past cell 39", isOn: $gs.allowContinuePast40)

                    LabeledContent("Round", value: "\(gameState.roundNumber)")
                    LabeledContent("Players", value: "\(gameState.players.count)")
                }

                if !gameState.players.isEmpty {
                    Section("Players") {
                        ForEach(gameState.players) { player in
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color(hex: player.colorHex))
                                    .frame(width: 24, height: 24)
                                Text(player.name)
                                Spacer()
                                Text("Cell \(player.position)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                gameState.removePlayer(id: gameState.players[index].id)
                            }
                        }
                    }
                }

                Section("Danger Zone") {
                    Button("Reset Positions") {
                        showResetConfirm = true
                    }
                    .foregroundStyle(.orange)

                    Button("Remove All Players") {
                        showRemoveAllConfirm = true
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Reset all positions to 0?", isPresented: $showResetConfirm) {
                Button("Reset", role: .destructive) { gameState.resetGame() }
                Button("Cancel", role: .cancel) { }
            }
            .alert("Remove all players?", isPresented: $showRemoveAllConfirm) {
                Button("Remove All", role: .destructive) { gameState.removeAllPlayers() }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}
