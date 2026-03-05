//
//  Player.swift
//  ImaginariumBoardiPad
//

import Foundation

struct Player: Identifiable, Hashable, Sendable {
    let id: UUID
    var name: String
    var colorHex: UInt
    var position: Int = 0

    init(name: String, colorHex: UInt) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
    }

    var initial: String {
        guard let first = name.first else { return "?" }
        return String(first).uppercased()
    }
}
