//
//  PlayerAddView.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 12.06.2022.
//

import SwiftUI

struct PlayerAddDialog: View {
    
    @EnvironmentObject var state: ImaginariumState
    
    @State var name: String = "" {
        didSet {
            state.dispatch(action: PlayerAction.testUpdate(color: color, name: name))
        }
    }
    @State var color: UInt {
        didSet {
            state.dispatch(action: PlayerAction.testUpdate(color: color, name: name))
        }
    }
    
    @Binding var isPlayerAddView: Bool
    
    var columns: [GridItem] = Array(repeating: .init(), count: 4)
    
    var body: some View {
        VStack(spacing:24){
            Text(name)
                .foregroundColor(Color(hex: color))
                .font(.title.bold())
            ModalTextEditor(placeholder: "Player name", string: $name, textEditorHeight: 48)
            
            HStack(spacing: 12) {
                LazyVGrid(columns: columns) {
                    ForEach(0..<PlayerState.playerColors.count, id: \.self) { i in
                        PlayerTrainTileView(title: PlayerState.playerColors[i].key,
                                            color: PlayerState.playerColors[i].value)
                        .onTapGesture {
                            color = PlayerState.playerColors[i].value
                        }
                    }
                }
            }
            .padding(.top, 10)
            
            Button {
                print("Save")
                isPlayerAddView.toggle()
            } label: {
                HStack{
                    Spacer()
                    Text("SAVE")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
            }
            .controlSize(.large)
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            .tint(.accentColor)
            
            Button {
                isPlayerAddView.toggle()
            } label: {
                HStack{
                    Spacer()
                    Text("Cancel")
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

/*struct PlayerAddView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAddView()
    }
}*/
