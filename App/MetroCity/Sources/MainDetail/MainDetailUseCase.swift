// Copyright © 2023 TDS. All rights reserved. 2023-11-16 목 오전 11:23 꿀꿀🐷

import SwiftUI

final class MainDetailUseCase {
    private let repository: SubwayRepositoryFetch
    
    init(repo: SubwayRepositoryFetch) {
        self.repository = repo
    }
    
    func fetchData() -> MainDetailModel {
        return .emptyData
    }
    
}
