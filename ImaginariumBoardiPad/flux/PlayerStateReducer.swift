//
//  PlayerStateReducer.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 07.06.2022.
//

import Foundation

protocol Action {}

enum PlayerAction: Action {
    case testData
    case testUpdate(color: UInt, name: String)
    
    case addPlayer
    case deletePlayer(index: Int)
    case move(from: Int, to: Int)
    case editPlayer(id:Int, name: String, nickname: String)
    case startUpdatingPlayer
    case stopUpdatingPlayer
}

protocol Reducer {
    
    associatedtype StateType
    func reduce(state: StateType, action: Action) -> StateType
    
}

struct PlayerStateReducer: Reducer {
    
    func reduce(state: PlayerState, action: Action) -> PlayerState {
        
        var state = state
        
        switch action {
          
        case PlayerAction.testData:
            state.add(newPlayers: PlayerState.playerColors
                                    .sorted { $0.value < $1.value }
                                    .map { Player(name: $0.key, color: $0.value) })
        case let PlayerAction.testUpdate(color, name):
            state.update(color: color, name: name)
        //case PlayerAction.addPlayer:
            
            /*state.players.append(Player(id: state.players.count,
                                        name: "New Player \(state.players.count)",
                                        nickname: "@nickname\(state.players.count)"))*/
            /*case let PlayerAction.deletePlayer(index):
            if state.players.count > 0 {
                state.players.remove(at: index)
            }
        case let PlayerAction.move(from, to):
            let player = state.players.remove(at: from)
            state.players.insert(player, at: to)
        case let PlayerAction.editPlayer(id, name, nickname):
            var player = state.players[id]
            player.name = name
            player.nickname = nickname
            state.players[id] = player
        case PlayerAction.startUpdatingPlayer:
            state.isUpdatingPlayer = true
        case PlayerAction.stopUpdatingPlayer:
            state.isUpdatingPlayer = false*/
        default:
            break
        }
        
        return state
    }
    
    
}
