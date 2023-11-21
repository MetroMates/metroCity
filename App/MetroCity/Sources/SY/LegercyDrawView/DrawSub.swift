// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷

import SwiftUI

struct SubwayLineMapView: View {
    var line: SubwayLineTemp
    @State private var moveSize: CGPoint = .init(x: 200, y: 500)
    @State private var isDragging: Bool = false
    @State private var scale: CGFloat = 0
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.moveSize = value.location
                self.isDragging = true
            }
            .onEnded { _ in
                self.isDragging = false
            }
    }
    
    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged({ chg in
                scale = chg - 1
            })
    }
    
    var body: some View {
        ZStack {
            Path { path in
                if let firstStation = line.stations.first {
                    path.move(to: firstStation.coordinates)
                    for station in line.stations.dropFirst() {
                        path.addLine(to: station.coordinates)
                    }
                }
            }
            .stroke(lineWidth: 5)
            .foregroundColor(line.color)
            
            // Draw stations
            ForEach(line.stations) { station in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.red)
                    .position(station.coordinates)
                
                Text(station.name)
                    .position(CGPoint(x: station.coordinates.x + 15, y: station.coordinates.y+10))
//                    .position(station.coordinates)
                    .onTapGesture {
                        print(station.name)
                    }
            }
        }
        .contentShape(Rectangle())
        .scaleEffect(1 + scale)
        .position(moveSize)
        .gesture(
            SimultaneousGesture(magnification, drag)
        )
    }
}

struct SubwayExampleView: View {
    var body: some View {
        SubwayLineMapView(line: 신분당선)
    }
}

// Example data for Line 2
let line2 = SubwayLineTemp(
    name: "Line 2",
    color: .blue,
    stations: [
        SubwayStationTemp(name: "시청역", coordinates: CGPoint(x: 50, y: 200)),
        SubwayStationTemp(name: "을지로 1가", coordinates: CGPoint(x: 150, y: 300)),
        SubwayStationTemp(name: "을지로 3가", coordinates: CGPoint(x: 200, y: 350)),
        SubwayStationTemp(name: "역삼역", coordinates: CGPoint(x: 300, y: 250)),
        SubwayStationTemp(name: "종로 3가", coordinates: CGPoint(x: 350, y: 200))
    ]
)

let 신분당선 = SubwayLineTemp(
    name: "Shinbundang Line",
    color: .green,
    stations: [
        SubwayStationTemp(name: "강남역", coordinates: CGPoint(x: 100, y: 200)),
        SubwayStationTemp(name: "양재역", coordinates: CGPoint(x: 150, y: 250)),
        SubwayStationTemp(name: "정자역", coordinates: CGPoint(x: 250, y: 300)),
        SubwayStationTemp(name: "판교역", coordinates: CGPoint(x: 300, y: 350)),
        SubwayStationTemp(name: "임재역", coordinates: CGPoint(x: 350, y: 400)),
        SubwayStationTemp(name: "동천역", coordinates: CGPoint(x: 400, y: 450)),
        SubwayStationTemp(name: "수정역", coordinates: CGPoint(x: 450, y: 500)),
        SubwayStationTemp(name: "야탑역", coordinates: CGPoint(x: 425, y: 475)),
        SubwayStationTemp(name: "분당역", coordinates: CGPoint(x: 375, y: 425)),
        SubwayStationTemp(name: "서현역", coordinates: CGPoint(x: 325, y: 375)),
        SubwayStationTemp(name: "기흥역", coordinates: CGPoint(x: 275, y: 325)),
        SubwayStationTemp(name: "전대에버랜드역", coordinates: CGPoint(x: 225, y: 275)),
        SubwayStationTemp(name: "광교중앙역", coordinates: CGPoint(x: 175, y: 225))
    ]
)

struct SubwayExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SubwayExampleView()
    }
}
