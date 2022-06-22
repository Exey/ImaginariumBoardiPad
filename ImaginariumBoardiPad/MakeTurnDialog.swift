//
//  MakeTurnDialog.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 22.06.2022.
//

import SwiftUI

struct MakeTurnDialog: View {
    
    @EnvironmentObject var state: ImaginariumState
    
    @Binding var isMakeTurnDialog: Bool
    
    var body: some View {
        VStack(spacing: 24){
            List() {
                Section {
                    ForEach($state.playerState.players.elements) { $player in
                        playerCell($player)
                    }
                }
                Section {
                    
                    Button {
                        isMakeTurnDialog.toggle()
                    } label: {
                        HStack{
                            Spacer()
                            Text("Close")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    .tint(.red)
                    
                }
            }

        }
    }
    
    func playerCell(_ player: Binding<Player>) -> some View {
        HStack {
            PlayerCardView(color: player.color, name: player.name, size: 80)
        }
    }
    
}
