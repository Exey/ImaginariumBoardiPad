//
//  ModalTextEditor.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 5/26/22.
//

import SwiftUI

struct ModalTextEditor: View {
    
    var placeholder : String = ""
    @Binding var string: String
    @State var textEditorHeight : CGFloat
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Text(string)
                .font(.title2)
                .foregroundColor(.clear)
                .padding(24)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
                })
            
            TextEditor(text: $string)
                .padding(.top, 10)
                .font(.title2)
                .cornerRadius(12.0)
                .foregroundColor(Color("textColor"))
                .multilineTextAlignment(.leading)
                .focused($isFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? .accentColor : Color.primary.opacity(0.5))
                )
                .overlay(
                    HStack{
                        Text(verbatim: string.isEmpty ? placeholder : "")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .disabled(true)
                            .allowsHitTesting(false)
                        Spacer()
                    }
                        .padding(.leading, 4)
                )
                .frame(height: string.isEmpty ? max(40,textEditorHeight) : max(40,textEditorHeight)-10)
                .background(
                    Color.primary
                        .opacity(0.1)
                        .cornerRadius(12)
                )
        }        
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
    }
}
                            
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
