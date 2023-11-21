import SwiftUI

struct MovingCircleWithoutCanvasView: View {
    @State private var circlePosition: CGPoint = CGPoint(x: 50, y: 150)
    
    var body: some View {
        VStack {
            // S자 모양의 선 그리기
            Path { path in
                path.move(to: CGPoint(x: 50, y: 150))
                path.addCurve(
                    to: CGPoint(x: 250, y: 150),
                    control1: CGPoint(x: 100, y: 50),
                    control2: CGPoint(x: 200, y: 250)
                )
            }
            .stroke(Color.blue, lineWidth: 6.0)
            .frame(width: 300, height: 300)
            
            // 이동하는 Circle 그리기
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.green)
                .position(x: circlePosition.x, y: circlePosition.y)
                .onAppear {
                    // Timer를 사용하여 1초마다 Circle의 위치를 업데이트
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        withAnimation(.linear(duration: 1.0)) {
                            self.circlePosition = self.calculateNextCirclePosition()
                        }
                    }
                }
        }
    }
    
    // 다음 Circle의 위치 계산
    private func calculateNextCirclePosition() -> CGPoint {
        // 경로의 중간 지점을 찾아서 반환
        let path = Path { path in
            path.move(to: CGPoint(x: 50, y: 150))
            path.addCurve(
                to: CGPoint(x: 250, y: 150),
                control1: CGPoint(x: 100, y: 50),
                control2: CGPoint(x: 200, y: 250)
            )
        }
        let pathLength = path.boundingRect.width
        let currentPosition = path.trimmedPath(from: 0.0, to: pathLength * 0.5).boundingRect
        let nextPosition = path.trimmedPath(from: pathLength * 0.5, to: pathLength).boundingRect.origin
        
        return nextPosition
    }
}

struct MovingCircleView_Preview: PreviewProvider {
    static var previews: some View {
        MovingCircleWithoutCanvasView()
    }
}
