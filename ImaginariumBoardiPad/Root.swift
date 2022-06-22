//
//  Root.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 30.05.2022.
//

import SwiftUI

struct Root: View {
    
    @EnvironmentObject var viewModel: TilesViewModel
    @EnvironmentObject var state: ImaginariumState
    
    @State var isPlayerAddDialog: Bool = false
    @State var isMakeTurnDialog: Bool = false
    
    var body: some View {
        ZStack {
            Image("sky")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            ScrollView {
                TilesView()
                    .padding(.top, 110)
                Spacer().frame(height: 20)
                PlayersTrainView()
                Spacer().frame(height: 20)
                buttons
            }
            .modal(isShowing: $isPlayerAddDialog, content: {
                PlayerAddDialog(color: state.playerState.unusedColor, isPlayerAddDialog: $isPlayerAddDialog)
                    .environmentObject(state)
            })
            .modal(isShowing: $isMakeTurnDialog, content: {
                MakeTurnDialog(isMakeTurnDialog: $isMakeTurnDialog)
                    .environmentObject(state)
            })
        }
    }
    
    var buttons: some View {
        HStack {
            GameControlButton {
                isPlayerAddDialog.toggle()
            } label: {
                Text("Add Player")
            }
            GameControlButton {
                isMakeTurnDialog.toggle()
            } label: {
                Text("Make Turn")
            }
            GameControlButton {
                state.dispatch(action: PlayerAction.testData)
                //print(state.playerState.players.elements.map{"\($0)"}.joined(separator: "\n"))
            } label: {
                Text("Test Data")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
