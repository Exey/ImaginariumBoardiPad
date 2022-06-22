//
//  PlayerCardView.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 22.06.2022.
//

import SwiftUI

struct PlayerCardView: View {
    
    @Binding var color: UInt
    @Binding var name: String
    
    var size: Double
    
    var firstNameCharacter: String {
        if name.isEmpty {
            return "questionmark"
        }
        return String(name.first!).lowercased()
    }
    
    var body: some View {
        
        Image(systemName: "\(firstNameCharacter).square.fill")
        //Text(name)
            .foregroundColor(Color(hex: color))
            .font(.system(size: size))
        
    }
    
}
