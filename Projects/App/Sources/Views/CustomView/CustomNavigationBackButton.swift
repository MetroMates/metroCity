// Copyright © 2023 TDS. All rights reserved. 2023-11-30 목 오후 03:29 꿀꿀🐷

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
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
