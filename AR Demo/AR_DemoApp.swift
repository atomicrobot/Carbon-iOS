import SwiftUI

@main
struct AR_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppManager.sharedInstance)
        }
    }
}
