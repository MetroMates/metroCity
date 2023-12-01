// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconStyle)
                .foregroundColor(style.themeColor)
            Text(message)
                .font(Font.caption)
        }
        .tint(Color.white)
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(colorScheme == .dark ? Color(uiColor: .systemGray4) : Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .opacity(0.1)
            
        )
        .padding(.horizontal, 16)
        
    }
}

struct ToastViewMain_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(style: .success, message: "성공", width: .infinity)
    }
}
