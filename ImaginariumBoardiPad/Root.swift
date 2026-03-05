//
//  Root.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct Root: View {

    @Environment(GameState.self) private var gameState

    @State private var showAddPlayer = false
    @State private var showScoring = false
    @State private var showSettings = false
    @State private var showWinner = false
    @State private var showManualMove = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(hex: 0x0F0C29),
                    Color(hex: 0x302B63),
                    Color(hex: 0x24243E)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, 8)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        leaderBanner
                            .padding(.horizontal, 20)

                        BoardView()
                            .padding(.horizontal, 12)

                        if !gameState.players.isEmpty {
                            PlayerListView()
                                .padding(.horizontal, 12)
                        }

                        controlButtons
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                    }
                    .padding(.top, 12)
                }
            }
        }
        .sheet(isPresented: $showAddPlayer) {
            PlayerAddDialog()
                .environment(gameState)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showScoring) {
            ScoringDialog()
                .environment(gameState)
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showSettings) {
            SettingsDialog()
                .environment(gameState)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showManualMove) {
            ManualMoveDialog()
                .environment(gameState)
                .presentationDetents([.large])
        }
        .alert("Winner!", isPresented: $showWinner) {
            Button("Continue Playing") {
                gameState.allowContinuePast40 = true
            }
            Button("New Game", role: .destructive) {
                gameState.resetGame()
            }
        } message: {
            let names = gameState.winners.map(\.name).joined(separator: ", ")
            Text("\(names) reached the finish! 🎉")
        }
        .onChange(of: gameState.isGameOver) { _, newValue in
            if newValue { showWinner = true }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("IMAGINARIUM")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                if gameState.roundNumber > 0 {
                    Text("Round \(gameState.roundNumber)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Leader Banner

    @ViewBuilder
    private var leaderBanner: some View {
        if let leader = gameState.currentLeader {
            let tileIndex = leader.position
            let tile = gameState.boardTiles.first { $0.index == tileIndex }
            let specialType = tile?.type ?? .empty

            HStack(spacing: 12) {
                PlayerAvatar(player: leader, size: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Leader: \(leader.name)")
                        .font(.headline)
                        .foregroundStyle(.white)

                    if specialType != .empty {
                        Label(specialType.label, systemImage: specialType.icon)
                            .font(.caption)
                            .foregroundStyle(specialType.color)
                    }
                }

                Spacer()

                Text("Cell \(leader.position)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: Capsule())
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: leader.colorHex).opacity(0.5), lineWidth: 2)
                    )
            )
        }
    }

    // MARK: - Buttons

    private var controlButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                actionButton("Add Player", icon: "person.badge.plus", color: .cyan) {
                    showAddPlayer = true
                }
                actionButton("New Round", icon: "play.fill", color: .green) {
                    showScoring = true
                }
                .disabled(gameState.players.count < 2)
                .opacity(gameState.players.count < 2 ? 0.4 : 1)
            }

            HStack(spacing: 12) {
                actionButton("Move", icon: "arrow.up.arrow.down", color: .orange) {
                    showManualMove = true
                }
                .disabled(gameState.players.isEmpty)
                .opacity(gameState.players.isEmpty ? 0.4 : 1)

                actionButton("Undo", icon: "arrow.uturn.backward", color: .yellow) {
                    gameState.undoLastRound()
                }
                .disabled(gameState.history.isEmpty)
                .opacity(gameState.history.isEmpty ? 0.4 : 1)

                actionButton("Test Data", icon: "flask.fill", color: .purple) {
                    gameState.loadTestData()
                }
            }
        }
    }

    private func actionButton(
        _ title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.semibold))
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(color.opacity(0.25), in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
    }
}
