//
//  Tile.swift
//  ImaginariumBoardiPad
//

import SwiftUI

enum TileType: Sendable {
    case empty
    case fourWords
    case question
    case brand
    case tv
    case narrative

    var icon: String {
        switch self {
        case .empty:      return ""
        case .fourWords:  return "textformat.abc"
        case .question:   return "questionmark.circle.fill"
        case .brand:      return "star.circle.fill"
        case .tv:         return "sparkles.tv.fill"
        case .narrative:  return "book.fill"
        }
    }

    var label: String {
        switch self {
        case .empty:      return ""
        case .fourWords:  return "4 Words"
        case .question:   return "Question"
        case .brand:      return "Brand"
        case .tv:         return "TV / Cinema"
        case .narrative:  return "Narrative"
        }
    }

    var color: Color {
        switch self {
        case .empty:      return .clear
        case .fourWords:  return .orange
        case .question:   return .cyan
        case .brand:      return .pink
        case .tv:         return .purple
        case .narrative:  return .green
        }
    }
}

struct Tile: Identifiable, Sendable {
    let index: Int
    var type: TileType

    var id: Int { index }

    init(index: Int, _ type: TileType = .empty) {
        self.index = index
        self.type = type
    }
}
