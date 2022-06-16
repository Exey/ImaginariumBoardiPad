//
//  PlayersView.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 08.06.2022.
//

import SwiftUI

struct PlayersTrainView: View {
    
    @EnvironmentObject var state: ImaginariumState
    
    var body: some View {
        HStack {
            ForEach(state.playerState.players.elements) { player in
                PlayerTrainTileView(title: player.name, color: player.color)
            }
        }
        .padding(.horizontal, 20)
    }
    
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersTrainView()
    }
}
