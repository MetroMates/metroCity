// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

struct SubwayRouteMapView: View {
    @ObservedObject var vm: MainDetailVM
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(vm.hosunInfo.lineColor.opacity(0.7))
                .frame(maxWidth: .infinity)
                .frame(height: 15)

            StationCircle("남한산성입구(성남법원,검찰청)")
            
        }
    }
}

extension SubwayRouteMapView {
    @ViewBuilder private func StationCircle(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(vm.hosunInfo.lineColor, lineWidth: 2)
                    .frame(height: 25)
//                    .frame(width: 55, height: 25)
                    .background {
                        Color.white
                    }
            }
    }
}

struct SubwayRouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailView(vm: MainDetailVM(useCase: MainDetailUseCase(repo: MainListRepository(networkStore: SubwayAPIService()))))
            .previewDisplayName("디테일")
        
        MainListView()
            .previewDisplayName("메인리스트")
    }
}
