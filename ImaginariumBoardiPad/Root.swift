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
    
    @State var isPlayerAddView: Bool = false
    
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
            .modal(isShowing: $isPlayerAddView, content: {
                PlayerAddDialog(color: state.playerState.unusedColor, isPlayerAddView: $isPlayerAddView)
                    .environmentObject(state)
            })
        }
    }
    
    var buttons: some View {
        HStack {
            GameControlButton {
                isPlayerAddView.toggle()
            } label: {
                Text("Add Player")
            }
            GameControlButton {
                state.dispatch(action: PlayerAction.testData)
            } label: {
                Text("Test Players")
            }
            GameControlButton {
                print(state.playerState.players.elements.map{"\($0)"}.joined(separator: "\n"))
            } label: {
                Text("Test")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
