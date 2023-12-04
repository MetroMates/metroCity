// Copyright © 2023 TDS. All rights reserved. 2023-12-03 일 오전 11:08 꿀꿀🐷

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        /* SwiftUI 에서 swipe pop gesture를 사용하기 위한 delgate 할당*/
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
