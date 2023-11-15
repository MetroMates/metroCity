// Copyright © 2023 TDS. All rights reserved. 2023-11-15 수 오후 06:43 꿀꿀🐷

import Foundation

// ViewModel에서 특정 동작이 일어났을경우의 비즈니스 로직이 동작하는 클래스
// 비즈니스 로직이란 View = 즉 UI와 관련되지 않은 모든 로직을 일컫는다.
final class MainListUseCase {
    private let repository: Repository = .init()
    
    func fetch(vm: MainListVM) async {
        let data = await repository.getMainList()
        
        vm.models = data
        
    }
    
}
