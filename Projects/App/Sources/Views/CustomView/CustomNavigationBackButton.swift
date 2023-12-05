// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset: CGFloat = 0
    
    // 이거 없어도 되는ㄴ데,,?
//    private func swipe(geo: GeometryProxy) -> some Gesture {
//        DragGesture(minimumDistance: 20)
//            .onChanged { value in
//                let valueTemp = value.translation.width
//                if valueTemp >= 0 { dragOffset = valueTemp }
//            }
//            .onEnded { value in
//                if value.translation.width > geo.size.width * 0.4 {
//                    dismiss()
//                }
//                dragOffset = 0
//            }
//    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
//                .offset(x: dragOffset)
//                .animation(.easeInOut(duration: 0.45), value: dragOffset)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: CustomBackButton())
//                .gesture(swipe(geo: geo))
        }
    }
}

struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .padding(.horizontal)
                .padding(.vertical, 5)
                .foregroundStyle(Color.primary)
                .frame(width: 30)
                .contentShape(Rectangle())
//                .border(.black)
            
        }
       
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButtonModifier())
    }
}

struct CustomBackButton_Preview: PreviewProvider {
    static var previews: some View {
        CustomBackButton()
    }
}
