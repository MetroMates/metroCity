// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷

import SwiftUI

struct SubwayMapViewdddd: View {
    var line: SubwayLineTemp

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw subway line
                Path { path in
                    for station in line.stations {
                        let point = CGPoint(x: station.coordinates.x * geometry.size.width, y: station.coordinates.y * geometry.size.height)
                        if station == line.stations.first {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(lineWidth: 5)
                .foregroundColor(line.color)

                // Draw stations
                ForEach(line.stations) { station in
                    let point = CGPoint(x: station.coordinates.x * geometry.size.width, y: station.coordinates.y * geometry.size.height)

                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.white)
                        .position(point)

                    // Add station names
                    Text(station.name)
                        .position(point)
                }
            }
        }
    }
}

struct DrawGeoView: View {
    var body: some View {
        SubwayMapViewdddd(line: shinbundangLine)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Example data for Line 2
let line3 = SubwayLineTemp(
    name: "Line 2",
    color: .blue,
    stations: [
        SubwayStationTemp(name: "City", coordinates: CGPoint(x: 0.1, y: 0.4)),
        SubwayStationTemp(name: "Euljiro 1-ga", coordinates: CGPoint(x: 0.3, y: 0.4)),
        SubwayStationTemp(name: "Euljiro 3-ga", coordinates: CGPoint(x: 0.4, y: 0.5)),
        SubwayStationTemp(name: "Yaksu", coordinates: CGPoint(x: 0.6, y: 0.5)),
        SubwayStationTemp(name: "Jongno 3(sam)-ga", coordinates: CGPoint(x: 0.7, y: 0.4))
    ]
)

let shinbundangLine = SubwayLineTemp(
    name: "Shinbundang Line",
    color: .orange,
    stations: [
        SubwayStationTemp(name: "Gangnam", coordinates: CGPoint(x: 0.2, y: 0.2)),
        SubwayStationTemp(name: "Yangjae", coordinates: CGPoint(x: 0.3, y: 0.3)),
        SubwayStationTemp(name: "Jeongja", coordinates: CGPoint(x: 0.5, y: 0.4)),
        SubwayStationTemp(name: "Pangyo", coordinates: CGPoint(x: 0.6, y: 0.5)),
        SubwayStationTemp(name: "Imae", coordinates: CGPoint(x: 0.7, y: 0.6)),
        SubwayStationTemp(name: "Dongcheon", coordinates: CGPoint(x: 0.8, y: 0.7)),
        SubwayStationTemp(name: "Sujeong", coordinates: CGPoint(x: 0.9, y: 0.8)),
        SubwayStationTemp(name: "Yatap", coordinates: CGPoint(x: 0.85, y: 0.75)),
        SubwayStationTemp(name: "Bundang", coordinates: CGPoint(x: 0.75, y: 0.65)),
        SubwayStationTemp(name: "Seohyeon", coordinates: CGPoint(x: 0.65, y: 0.55)),
        SubwayStationTemp(name: "Giheung", coordinates: CGPoint(x: 0.55, y: 0.45)),
        SubwayStationTemp(name: "Jeondae-Everland", coordinates: CGPoint(x: 0.45, y: 0.35)),
        SubwayStationTemp(name: "Gwanggyo Jungang", coordinates: CGPoint(x: 0.35, y: 0.25))
    ]
)

struct DrawGeoView_Previews: PreviewProvider {
    static var previews: some View {
        DrawGeoView()
    }
}
