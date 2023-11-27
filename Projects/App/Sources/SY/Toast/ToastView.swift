// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 03:32 꿀꿀🐷

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconStyle)
                .foregroundColor(style.themeColor)
            Text(message)
                .font(Font.caption)
                .foregroundColor(Color.black)
                .lineLimit(1)
        }
        .background(Color.white)
        .tint(Color.white)
        .foregroundColor(.white)
        .padding()
        .frame(minWidth: 0, maxWidth: width)
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
