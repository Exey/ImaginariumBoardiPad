//
//  ImaginariumState.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 07.06.2022.
//

import Foundation
import SwiftUI
import Combine

final class ImaginariumState: ObservableObject {
    
    var objectWillChange = PassthroughSubject<ImaginariumState, Never>()
    
    @Published var playerState: PlayerState
    
    init(playerState: PlayerState = PlayerState()) {
        self.playerState = playerState
    }
    
    func dispatch(action: Action) {
        playerState = PlayerStateReducer().reduce(state: playerState, action: action)
        objectWillChange.send(self)
    }
    
}
