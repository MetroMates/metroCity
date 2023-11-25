// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 02:53 꿀꿀🐷

import SwiftUI

/// Text와 같은 기능의 View
/// Text content의 길이가 Parent frame보다 길경우 offset을 조절하여 보여준다.
struct ScrollText: View {
    @State private var textHeight: CGFloat = .zero
    @State private var textWidth: CGFloat = .zero
    @State private var offset: CGFloat = .zero
    @State private var parentWidth: CGFloat = .zero
    @State private var isdisabled: Bool = false
    
    /// Text Content
    let content: String
    /// 스크롤 스피드
    var transSpeed: Double = 7.0
    
    var body: some View {
        GeometryReader { g in
            ScrollView(.horizontal, showsIndicators: false) {
                Text(content)
                    .offset(x: offset)
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    textHeight = geo.size.height
                                    textWidth = geo.size.width
                                    parentWidth = g.size.width
                                }
                        }
                    }
            }
            .onAppear {
                withAnimation(.linear(duration: transSpeed).repeatForever(autoreverses: false)) {
                    if parentWidth < textWidth {
                        offset = -textWidth / 2 // text길이의 절반까지만 움직이면 됨
                    } else {
                        isdisabled = true
                    }
                }
            }
        }
        .frame(maxWidth: parentWidth == .zero ? nil : textWidth)
        .frame(maxHeight: textHeight)
        .disabled(isdisabled)
    }
    
}

struct ScrollText_Previews: PreviewProvider {
    static var previews: some View {
        ScrollText(content: "남한산성(경마공원어리둥절)")
    }
}
