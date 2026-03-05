//
//  GameState.swift
//  ImaginariumBoardiPad
//

import SwiftUI
import Observation

@Observable
final class GameState {

    // MARK: - Player Colors (16 total)

    static let playerColors: [(name: String, hex: UInt)] = [
        ("Black",      0x1A1A2E),
        ("White",      0xE8E8E8),
        ("Gray",       0x808080),
        ("Red",        0xE63946),
        ("Orange",     0xFF8C42),
        ("Yellow",     0xFFD60A),
        ("Light Pink", 0xFFB6C1),
        ("Magenta",    0xE040FB),
        ("Violet",     0x7C4DFF),
        ("Blue",       0x2979FF),
        ("Turquoise",  0x00BFA5),
        ("Light Blue", 0x80D8FF),
        ("Dark Green", 0x2E7D32),
        ("Acid Green", 0x76FF03),
        ("Brown",      0x6D4C41),
        ("Beige",      0xD7CCC8),
    ]

    // MARK: - State

    var players: [Player] = []
    var currentLeaderIndex: Int = 0
    var roundNumber: Int = 0
    var allowContinuePast40: Bool = true
    var history: [RoundSnapshot] = []

    // Board tiles — built once
    let boardTiles: [Tile]
    // Pre-computed grid layout (serpentine, 4 columns)
    let boardGrid: [[Tile]]

    // MARK: - Computed

    var currentLeader: Player? {
        guard !players.isEmpty else { return nil }
        let idx = currentLeaderIndex % players.count
        return players[idx]
    }

    var isGameOver: Bool {
        players.contains { $0.position >= 39 } && !allowContinuePast40
    }

    var winners: [Player] {
        guard let maxPos = players.map(\.position).max(), maxPos >= 39 else { return [] }
        return players.filter { $0.position == maxPos }
    }

    var usedColors: Set<UInt> {
        Set(players.map(\.colorHex))
    }

    var availableColors: [(name: String, hex: UInt)] {
        Self.playerColors.filter { !usedColors.contains($0.hex) }
    }

    var nextAvailableColor: UInt {
        availableColors.first?.hex ?? 0x808080
    }

    // MARK: - Init

    init() {
        let tiles = GameState.buildBoard()
        boardTiles = tiles
        boardGrid = GameState.buildGrid(from: tiles)
    }

    // MARK: - Player Management

    func addPlayer(name: String, colorHex: UInt) {
        guard !usedColors.contains(colorHex) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        players.append(Player(name: trimmed, colorHex: colorHex))
    }

    func removePlayer(id: UUID) {
        players.removeAll { $0.id == id }
        if currentLeaderIndex >= players.count {
            currentLeaderIndex = 0
        }
    }

    func movePlayer(id: UUID, by delta: Int) {
        guard let idx = players.firstIndex(where: { $0.id == id }) else { return }
        let newPos = max(0, players[idx].position + delta)
        players[idx].position = newPos
    }

    func setPlayerPosition(id: UUID, position: Int) {
        guard let idx = players.firstIndex(where: { $0.id == id }) else { return }
        players[idx].position = max(0, position)
    }

    // MARK: - Round Scoring

    /// Apply round results: moves each player by given deltas and advances the leader.
    func applyRound(deltas: [UUID: Int]) {
        // Save snapshot for undo
        history.append(RoundSnapshot(
            players: players,
            leaderIndex: currentLeaderIndex,
            roundNumber: roundNumber
        ))

        for (id, delta) in deltas {
            movePlayer(id: id, by: delta)
        }
        roundNumber += 1
        advanceLeader()
    }

    func undoLastRound() {
        guard let snapshot = history.popLast() else { return }
        players = snapshot.players
        currentLeaderIndex = snapshot.leaderIndex
        roundNumber = snapshot.roundNumber
    }

    func advanceLeader() {
        guard !players.isEmpty else { return }
        currentLeaderIndex = (currentLeaderIndex + 1) % players.count
    }

    // MARK: - Game Control

    func resetGame() {
        for i in players.indices {
            players[i].position = 0
        }
        currentLeaderIndex = 0
        roundNumber = 0
        history.removeAll()
    }

    func removeAllPlayers() {
        players.removeAll()
        currentLeaderIndex = 0
        roundNumber = 0
        history.removeAll()
    }

    func loadTestData() {
        removeAllPlayers()
        for entry in Self.playerColors {
            players.append(Player(name: entry.name, colorHex: entry.hex))
        }
    }

    // MARK: - Board Construction

    /// The board is cells 1…39 arranged in a serpentine 4-column grid.
    /// Row 0: 10, 11, 28, 29  (left-to-right)
    /// Row 1:  9, 12, 27, 30  …
    /// etc. Matches the original layout.
    private static func buildBoard() -> [Tile] {
        var tiles: [Tile] = (1...39).map { Tile(index: $0) }

        let specials: [(TileType, [Int])] = [
            (.fourWords, [3, 18, 25, 28]),
            (.tv,        [5, 21, 31, 38]),
            (.question,  [6, 10, 17, 26]),
            (.narrative, [8, 15, 19, 32]),
            (.brand,     [12, 23, 29, 35]),
        ]
        for (type, indices) in specials {
            for idx in indices {
                if let i = tiles.firstIndex(where: { $0.index == idx }) {
                    tiles[i].type = type
                }
            }
        }
        return tiles
    }

    /// Arrange tiles into the serpentine grid matching original layout.
    private static func buildGrid(from tiles: [Tile]) -> [[Tile]] {
        // The physical board layout: 4 columns, serpentine.
        // Column mapping for each row (matching the original TilesViewModel order):
        let layout: [[Int]] = [
            [10, 11, 28, 29],
            [ 9, 12, 27, 30],
            [ 8, 13, 26, 31],
            [ 7, 14, 25, 32],
            [ 6, 15, 24, 33],
            [ 5, 16, 23, 34],
            [ 4, 17, 22, 35],
            [ 3, 18, 21, 36],
            [ 2, 19, 20, 37],
            [ 1, 39, 38,  0],  // 0 = placeholder (no cell)
        ]

        let tileMap = Dictionary(uniqueKeysWithValues: tiles.map { ($0.index, $0) })

        return layout.map { row in
            row.compactMap { idx in
                guard idx > 0 else { return nil }
                return tileMap[idx]
            }
        }
    }

    func playersOnTile(_ tileIndex: Int) -> [Player] {
        players.filter { $0.position == tileIndex }
    }
}

// MARK: - Round Snapshot (for undo)

struct RoundSnapshot {
    let players: [Player]
    let leaderIndex: Int
    let roundNumber: Int
}
