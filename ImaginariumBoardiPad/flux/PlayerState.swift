//
//  struct .swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 07.06.2022.
//

import SwiftUI

struct PlayerState {
    
    static let playerColors: [(key: String, value: UInt)] = _playerColors.sorted { $0.value < $1.value }
    static let _playerColors: [String: UInt] = [
        "black"     : 0x000000,
        "white"     : 0xffffff,
        "gray"      : 0x808080,
        "orange"    : 0xffa500,
        "yellow"    : 0xffff00,
        "red"       : 0xff0000,
        "lite pink" : 0xFFB6C1,
        "magenta"   : 0xff00ff,
        "violet"    : 0x9500FF,
        "blue"      : 0x0000ff,
        //
        "turquoise" : 0x42D7D9,
        "lite blue" : 0xADD8E6,
        "dark green": 0x006400,
        "acid green": 0x76BB68,
        "brown"     : 0x4b371c,
        "beige"     : 0xc7a68b,
    ]

    var players: Queue<Player> = .init()
    var isUpdatingPlayer = false
    
    var unusedColor: UInt {
        let allColors: [UInt] = PlayerState.playerColors.map { $0.value }
        let usedColors: [UInt] = players.elements.map { $0.color }
        
        print(usedColors)
        print(allColors)
        
        let diff = allColors.applying(allColors.difference(from: usedColors))
        print(diff as Any)
        
        //var diffArray: [UInt] = .init()
        //allColors.difference(from: usedColors).forEach { diffArray.append( $0. ) }
        //print(diffArray)
        return diff?.first ?? 0
    }
        
    mutating func add(newPlayers: [Player] = []) {
        newPlayers.forEach{ players.enqueue($0) }
    }
    
    mutating func update(color: UInt, name: String) {
        if let index = players.elements.firstIndex(where: { $0.color == color}) {
            players.elements[index].name = name
        }
    }
    
}
