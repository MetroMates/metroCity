// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct LineWithCircleView: View {
    var body: some View {
//        let resultPoint = drawLineWithCircle(
//            color: .blue,
//            length: 100.0,
//            curvature: 20.0,
//            angle: 45.0,
//            direction: 1.0,
//            lineWidth: 3.0
//        )
        
        Canvas { context, size in
            drawLineWithCircle(context: context,
                               color: .blue,
                               length: 20.0,
                               curvature: 0,
                               angle: 0.0,
                               direction: 10.0,
                               lineWidth: 6.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // 결과 좌표 출력
//            print("결과 좌표: \(resultPoint)")
        }
    }
    
    func drawLineWithCircle(context: GraphicsContext,
                            color: Color,
                            length: CGFloat,
                            curvature: CGFloat,
                            angle: CGFloat,
                            direction: CGFloat,
                            lineWidth: CGFloat) -> Path {
        
        var startPoint = CGPoint(x: 50, y: 150)
        
        var path = Path()
        path.move(to: startPoint)
        
        // 라인 그리기
        let radians = angle * .pi / 180.0
        let deltaX = cos(radians) * length * direction
        let deltaY = sin(radians) * length * direction
        let endPoint = CGPoint(x: startPoint.x + deltaX, y: startPoint.y + deltaY)
        path.addQuadCurve(to: endPoint, control: CGPoint(x: startPoint.x + curvature * direction, y: startPoint.y - curvature))
        
        // 라인 스타일 설정
        context.stroke(path, with: .color(color), lineWidth: lineWidth)
        
        // Circle 그리기
        let circleRadius: CGFloat = lineWidth * 2.0
        let circleCenter = endPoint

        context.fill(
            Circle()
                .path(in: CGRect(x: circleCenter.x - circleRadius,
                                     y: circleCenter.y - circleRadius,
                                     width: circleRadius * 2,
                                     height: circleRadius * 2)),
            with: .foreground)
            
        return path
    }
}

struct SubwayLineView_Preview: PreviewProvider {
    static var previews: some View {
        LineWithCircleView()
    }
}
