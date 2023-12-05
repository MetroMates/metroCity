import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UITextField.appearance().tintColor = .darkGray
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct MetroCityTDSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var startVM: StartVM = .init(type: .real)
    
    var body: some Scene {
        WindowGroup {
            StartView(startVM: startVM)
        }
    }
}
