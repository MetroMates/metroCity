// Copyright © 2023 TDS. All rights reserved. 2023-11-22 수 오전 02:53 꿀꿀🐷

import SwiftUI
import Combine

/// Text와 같은 기능의 View
/// Text content의 길이가 Parent frame보다 길경우 offset을 조절하여 보여준다.
struct ScrollText: View {
    /// Text Content 높이
    @State private var textHeight: CGFloat = .zero
    /// Text Content 너비
    @State private var textWidth: CGFloat = .zero
    /// Text Content offSet
    @State private var offset: CGFloat = .zero
    /// Text Content 부모계층 너비
    @State private var parentWidth: CGFloat = .zero
    @State private var isdisabled: Bool = false
    /// Text Content
    let content: String
    /// 스크롤 스피드
    var transSpeed: Double = 2
    var moveOptn: Bool = true
    /// 길이와 상관없이 스크롤 막기.
    var disabled: Bool = false
    var handler: (_ parentWidth: CGFloat, _ textWidth: CGFloat) -> Void = { _, _ in }
    
    var body: some View {
        GeometryReader { g in
            ScrollView(.horizontal, showsIndicators: false) {
                Text(content)
                    .offset(x: offset)
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    setting(geo: geo) // 🔴 textWidth먼저 세팅하고 그다음 parentWidth세팅해줘야 한다. parentWidth는 onAppear때 한번만 세팅!!
                                    parentWidth = g.size.width
                                    handler(parentWidth, textWidth)
                                }
                                .onChange(of: content) { _ in
//                                    print("🟢🔵\(content) -> \(newValue)")
                                    stopAnimation()
                                    setting(geo: geo)
                                    startAnimation()
                                }
                        }
                    }
            }
            
        }
        .frame(maxWidth: parentWidth == .zero ? nil : textWidth)
        .frame(height: textHeight)
        .disabled(disabled ? true : isdisabled)
        // 부모View가 onAppear 될때 withAnimation은 한번만 써줘야 중첩되지 않음.
        .onAppear {
            startAnimation()
        }
    }
    
    private func setting(geo: GeometryProxy) {
//        print("🟢🆚Before: ", "|\(content)|", "W: \(textWidth)", "ParentW: \(parentWidth)")
        textHeight = geo.size.height
        textWidth = geo.size.width
//        print("🟢", "|\(content)|", "W: \(textWidth)", "ParentW: \(parentWidth)")
    }
    
    private func startAnimation() {
        if moveOptn {
            withAnimation(.linear(duration: transSpeed).delay(0.5).repeatForever(autoreverses: false)) {
//                print("🔴🟢", "|\(content)|", "W: \(textWidth)", "ParentW: \(parentWidth)")
                if parentWidth < textWidth {
//                    print("🔴🟢 애니메이션 시작!")
                    isdisabled = false
                    offset = -((textWidth) / 2)
                } else {
                    stopAnimation()
                }
            }
        }
     }
    
    // 애니메이션 중지
    private func stopAnimation() {
//        print("🟢🟢 애니메이션 중지")
        withAnimation {
            offset = .zero
            isdisabled = true
        }
    }
    
}

struct ScrollText_Previews: PreviewProvider {
    static var previews: some View {
        ScrollText(content: "남한산성(경마공원어리둥절)")
        
        MainListPreviewView()
            .previewDisplayName("메인리스트")
    }
}
