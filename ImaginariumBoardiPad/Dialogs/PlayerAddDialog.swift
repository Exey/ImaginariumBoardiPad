//
//  PlayerAddDialog.swift
//  ImaginariumBoardiPad
//

import SwiftUI

struct PlayerAddDialog: View {

    @Environment(GameState.self) private var gameState
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedColor: UInt?

    private var effectiveColor: UInt {
        selectedColor ?? gameState.nextAvailableColor
    }

    private var canSave: Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && !gameState.usedColors.contains(effectiveColor)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                avatarPreview
                nameField
                colorGrid
                saveButton
                Spacer()
            }
            .padding(20)
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // MARK: - Subviews

    private var avatarPreview: some View {
        let displayName = name.isEmpty ? "?" : name
        return PlayerAvatar(
            player: Player(name: displayName, colorHex: effectiveColor),
            size: 80,
            showName: true
        )
        .padding(.top, 8)
    }

    private var nameField: some View {
        TextField("Player name", text: $name)
            .font(.title3)
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }

    private var colorGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<GameState.playerColors.count, id: \.self) { index in
                colorCell(for: index)
            }
        }
    }

    private func colorCell(for index: Int) -> some View {
        let entry = GameState.playerColors[index]
        let isUsed = gameState.usedColors.contains(entry.hex)
        let isSelected = effectiveColor == entry.hex

        return Button {
            if !isUsed {
                selectedColor = entry.hex
            }
        } label: {
            colorCellLabel(name: entry.name, hex: entry.hex, isUsed: isUsed, isSelected: isSelected)
        }
        .disabled(isUsed)
        .opacity(isUsed ? 0.4 : 1.0)
    }

    private func colorCellLabel(name: String, hex: UInt, isUsed: Bool, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(Color(hex: hex))
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
                )
                .overlay {
                    if isUsed {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                }

            Text(name)
                .font(.system(size: 10))
                .foregroundStyle(isUsed ? .secondary : .primary)
                .lineLimit(1)
        }
    }

    private var saveButton: some View {
        Button {
            gameState.addPlayer(name: name, colorHex: effectiveColor)
            name = ""
            selectedColor = nil
        } label: {
            Text("ADD PLAYER")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(Color.green.opacity(0.7), in: RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!canSave)
    }
}
