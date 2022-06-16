//
//  GameControlButton.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 10.06.2022.
//

import SwiftUI

public struct GameControlButton<Content>: View where Content: View {
    
    private let action: () -> Void
    private let label: () -> Content
    
    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        label()
            .font(.title)
            .padding()
            .padding(.bottom, 2)
            .foregroundColor(.white)
            .background(Color(hex: 0x3b3b5c))
            .cornerRadius(16)
        .fixedSize(horizontal: true, vertical: true)
        .simultaneousGesture(
            TapGesture().onEnded {
                action()
            }
        )
    }
    
}
