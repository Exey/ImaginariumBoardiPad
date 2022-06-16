//
//  Modal.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 1/15/22.
//

import SwiftUI

extension View{
    
    func modal<ModalContent:View>(isShowing: Binding<Bool>, @ViewBuilder content:@escaping ()->ModalContent)->some View{
        self.modifier(Modal(isShowing: isShowing, dialogContent: content))
    }
}


struct Modal<ModalContent:View>: ViewModifier {
    
    @Binding
    private var isShowing:Bool
    private var dialogContent:ModalContent
    
    @Environment(\.colorScheme) var colorScheme
    
    init(isShowing:Binding<Bool>, @ViewBuilder dialogContent:@escaping ()->ModalContent ){
        self._isShowing = isShowing
        self.dialogContent = dialogContent()
    }
    
    func body(content:Content) -> some View {
        ZStack {
            content
            if isShowing {
                // the semi-transparent overlay
                Rectangle().foregroundColor(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut, value: isShowing)
                // the dialog content is in a ZStack to pad it from the edges
                // of the screen
                ZStack {
                    dialogContent
                        .frame(maxWidth:600)
                }
                .transition(.scale)
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(Color("dialogBackground"))
                )
            }
        }
        .animation(.spring(response: 0.5,
                           dampingFraction: isShowing ? 0.6 : 0.8 ,
                           blendDuration: isShowing ? 1.2 : 1)
            .speed(isShowing ? 1 : 1.5), value: isShowing)
    }
}

struct Modal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            
        }
        .preferredColorScheme(.dark)
        .modal(isShowing: .constant(true)){
            VStack{
                Text("Hello".uppercased())
                    .fontWeight(.bold)
                Text("Message")
                
                HStack{
                    Button("Hello"){
                        
                    }
                    
                    Button("Hello"){
                        
                    }
                }
            }
            .padding()
        }
    }
}
