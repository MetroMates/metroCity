//// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 12:21 꿀꿀🐷
//
//import SwiftUI
//
//struct APITestMainView: View {
////    let apiKey = Bundle.main.object(forInfoDictionaryKey: "TRAIN_API_KEY")
//    var netWorkManager = NetworkManager.shared
//    var searchTerm: String = "양재"
//    @State var requestSubway: Subway?
//
//    var body: some View {
//        VStack {
//            Button {
//                Task {
//                    do {
//                        self.requestSubway = try await netWorkManager.fetchSubway(searchTerm: searchTerm, searchNum: "5")
//                    } catch {
//                        print("error!!!: \(error)")
//                    }
//                }
//            } label: {
//                Text("Test중")
//            }
//
//            Text(requestSubway?.realtimeArrivalList.first?.trainLineNm.description ?? "kkk")
//
//        }
//    }
//}
//
//struct APITestMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        APITestMainView()
//    }
//}
