// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

enum DrawPattern {
    case L2R
    case R2L
    
}

struct DrawLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: .zero))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: .zero))
            
        }
    }
}

struct DrawLine_Previews: PreviewProvider {
    static var previews: some View {
        DrawLine()
    }
}
