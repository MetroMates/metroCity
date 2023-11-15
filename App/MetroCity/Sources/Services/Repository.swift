// Copyright © 2023 TDS. All rights reserved. 2023-11-14 화 오후 01:06 꿀꿀🐷

import Foundation

// 네트워크 통신을 하여 json으로 가져온 데이터를 디코딩까지 하고 객체로 반환해주는 곳.
final class Repository {
    private let userNetworkStore = TrainAPIConnect(key: .train) // 통신
//    private let userDBStore = UserDBStore() // 로컬

//    func getUser() -> User {
        // Combine data from network and DB if needed
//        let networkData = userNetworkStore.fetchUserData()
//        let dbData = userDBStore.fetchUserData()
//        return User(name: networkData.name, age: dbData.age)
//    }
    
    func getMainList() async {
        await userNetworkStore.load(type: <#T##SubwayModeling.Protocol#>, urlAddress: .trainArrive, station: "서울")
    }
    
}

