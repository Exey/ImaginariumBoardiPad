//
//  PlayerTrainTileView.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 17.06.2022.
//

import SwiftUI

struct PlayerTrainTileView: View {
    
    let title: String
    let color: UInt
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(hex: color))
            VStack {
                Text(title)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 4)
                    .shadow(color: .black, radius: 4)
            }
            .frame(height: 68)
        }
    }
    
}
