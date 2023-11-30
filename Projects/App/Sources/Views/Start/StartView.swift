// Copyright © 2023 TDS. All rights reserved.

import SwiftUI

struct StartView: View {
    private let startVM: StartVM = .init(type: .real)
    
    var body: some View {
        MainListView(mainVM: MainListVM(useCase: MainListUseCase(repo: MainListRepository(networkStore: SubwayAPIService())),
                                        startVM: startVM),
                     
                     mainDetailVM: MainDetailVM(useCase: MainDetailUseCase(repo: MainDetailRepository(networkService: SubwayAPIService())),
                                                startVM: startVM))
    }
}

struct StartView_Preview: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
