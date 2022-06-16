//
//  User.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 07.06.2022.
//

import Foundation

struct Player: Identifiable, Hashable, CustomStringConvertible {
    
    var description: String {
        "\(name) - \(position) - \(color) - \(isPlaying)"
    }
    
    var name: String
    var color: UInt
    
    var position: UInt = 0
    var isPlaying: Bool = false
    
    var id: UInt { color }
}
