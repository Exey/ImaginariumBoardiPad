//
//  ScoringDialog.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct ScoringDialog: View {

    @Environment(GameState.self) private var gameState
    @Environment(\.dismiss) private var dismiss

    // Who guessed the leader's card correctly
    @State private var correctGuessers: Set<UUID> = []
    // How many votes each non-leader's card received from OTHER players
    @State private var bonusVotes: [UUID: Int] = [:]

    private var leader: Player? { gameState.currentLeader }

    private var nonLeaders: [Player] {
        guard let leader else { return [] }
        return gameState.players.filter { $0.id != leader.id }
    }

    /// Whether ALL non-leaders guessed correctly
    private var allGuessed: Bool {
        !nonLeaders.isEmpty && correctGuessers.count == nonLeaders.count
    }

    /// Whether NOBODY guessed correctly
    private var noneGuessed: Bool {
        correctGuessers.isEmpty
    }

    // MARK: - Computed Scores

    private var leaderScore: Int {
        if allGuessed || noneGuessed { return 0 }
        return 3 + correctGuessers.count
    }

    private func playerScore(for player: Player) -> Int {
        var score = 0
        if correctGuessers.contains(player.id) {
            score += 3
        }
        score += bonusVotes[player.id, default: 0]
        return score
    }

    private var deltas: [UUID: Int] {
        var result: [UUID: Int] = [:]
        if let leader {
            result[leader.id] = leaderScore
        }
        for p in nonLeaders {
            result[p.id] = playerScore(for: p)
        }
        return result
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let leader {
                        leaderSection(leader)
                    }

                    Divider().overlay(.white.opacity(0.2))

                    guessingSection

                    Divider().overlay(.white.opacity(0.2))

                    bonusVotesSection

                    Divider().overlay(.white.opacity(0.2))

                    scoreSummary

                    applyButton
                }
                .padding(20)
            }
            .navigationTitle("Round \(gameState.roundNumber + 1) Scoring")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    // MARK: - Leader Section

    private func leaderSection(_ leader: Player) -> some View {
        HStack(spacing: 12) {
            PlayerAvatar(player: leader, size: 50)
            VStack(alignment: .leading) {
                Text("Leader this round")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(leader.name)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
            }
            Spacer()
            Image(systemName: "crown.fill")
                .font(.title2)
                .foregroundStyle(.yellow)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Guessing Section

    private var guessingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Who guessed the leader's card?")
                .font(.headline)
                .foregroundStyle(.white)

            ForEach(nonLeaders) { player in
                Button {
                    toggleGuess(player.id)
                } label: {
                    HStack(spacing: 12) {
                        PlayerAvatar(player: player, size: 36)

                        Text(player.name)
                            .foregroundStyle(.white)

                        Spacer()

                        Image(systemName: correctGuessers.contains(player.id) ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundStyle(correctGuessers.contains(player.id) ? .green : .secondary)
                    }
                    .padding(10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }

            if allGuessed {
                Label("All guessed — leader gets 0 points (too easy!)", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            } else if noneGuessed {
                Label("Nobody guessed — leader gets 0 points (too hard!)", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
    }

    // MARK: - Bonus Votes

    private var bonusVotesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bonus votes received")
                .font(.headline)
                .foregroundStyle(.white)

            Text("How many other players voted for each player's card?")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(nonLeaders) { player in
                HStack(spacing: 12) {
                    PlayerAvatar(player: player, size: 30)

                    Text(player.name)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Spacer()

                    HStack(spacing: 8) {
                        Button {
                            let current = bonusVotes[player.id, default: 0]
                            if current > 0 { bonusVotes[player.id] = current - 1 }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }

                        Text("\(bonusVotes[player.id, default: 0])")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(width: 30)

                        Button {
                            let current = bonusVotes[player.id, default: 0]
                            bonusVotes[player.id] = current + 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    // MARK: - Summary

    private var scoreSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ROUND SUMMARY")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            if let leader {
                scoreRow(player: leader, delta: leaderScore, isLeader: true)
            }
            ForEach(nonLeaders) { player in
                scoreRow(player: player, delta: playerScore(for: player), isLeader: false)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func scoreRow(player: Player, delta: Int, isLeader: Bool) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(hex: player.colorHex))
                .frame(width: 16, height: 16)

            Text(player.name)
                .font(.subheadline)
                .foregroundStyle(.white)

            if isLeader {
                Image(systemName: "crown.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(.yellow)
            }

            Spacer()

            Text(delta > 0 ? "+\(delta)" : "\(delta)")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(delta > 0 ? .green : .secondary)

            Text("→ \(player.position + delta)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Apply

    private var applyButton: some View {
        Button {
            gameState.applyRound(deltas: deltas)
            dismiss()
        } label: {
            Text("APPLY SCORES")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(.green.opacity(0.7), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(.bottom, 20)
    }

    // MARK: - Helpers

    private func toggleGuess(_ id: UUID) {
        if correctGuessers.contains(id) {
            correctGuessers.remove(id)
        } else {
            correctGuessers.insert(id)
        }
    }
}
