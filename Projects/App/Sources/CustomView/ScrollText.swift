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
    var transSpeed: Double = 2
    var moveOptn: Bool = true
    
    var body: some View {
        GeometryReader { g in
            ScrollView(.horizontal, showsIndicators: false) {
                Text(content)
                    .offset(x: offset)
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    setting(geo: geo, g: g)
                                }
                                .onChange(of: content) { _ in
                                    setting(geo: geo, g: g)
                                }
                        }
                    }
            }
            
        }
        .frame(maxWidth: parentWidth == .zero ? nil : textWidth)
        .frame(height: textHeight)
        .disabled(isdisabled)
        // 부모View가 onAppear 될때 withAnimation은 한번만 써줘야 중첩되지 않음.
        .onAppear {
            if moveOptn {
                withAnimation(.linear(duration: transSpeed).delay(0.5).repeatForever(autoreverses: false)) {
                    if parentWidth < textWidth {
                        offset = -((textWidth + 1) / 3)  // text길이의 1/3까지만 움직이면 됨 +1해준이유는 너무 바로 끝나서 조금더 진행 된후에 offset 초기화 시키기 위함.
                    } else {
                        isdisabled = true
                    }
                }
            }
        }
    }
    
    private func setting(geo: GeometryProxy, g: GeometryProxy) {
        textHeight = geo.size.height
        textWidth = geo.size.width
        parentWidth = g.size.width
        print("🟢", "|\(content)|", "W: \(textWidth)", "H: \(textHeight)", "ParentW: \(parentWidth)")
    }
    
}

struct ScrollText_Previews: PreviewProvider {
    static var previews: some View {
        ScrollText(content: "남한산성(경마공원어리둥절)")
        
        MainListView()
            .previewDisplayName("메인리스트")
    }
}
