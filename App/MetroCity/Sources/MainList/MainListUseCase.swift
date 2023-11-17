// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation

// ViewModel에서 특정 동작이 일어났을경우의 비즈니스 로직이 동작하는 클래스
// 비즈니스 로직이란 View = 즉 UI와 관련되지 않은 모든 로직을 일컫는다.
final class MainListUseCase {
    // SubwayRepositoryFetch 프로토콜을 채택하는 레포지토리를 외부에서 생성하여 주입받는다.
    // 특정 Repository 객체(타입)를 의존하지 않음을 뜻함. => 해당 추상화프로토콜을 따르는 어떤 Repository라도 사용이 가능함을 의미.
    private let repository: SubwayRepositoryFetch
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
    }
    
    // MainList에 대한 UseCase이니까 MainListVM 타입을 특정하여 받아와서 사용해도 무관.
    func fetchData(station: String) async -> [MainListModel] {
        let data = await repository.subwaysFetch(modelType: MainListModel.self, station: station)
        print("data \(data)")
        return data
    }
    
    // 호선 정보만 필터링해서 가져옴.
    
}
