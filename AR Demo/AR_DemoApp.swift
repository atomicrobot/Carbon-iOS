import ARNetworking
import SwiftUI

@main
struct AR_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(appManager: AppManager.sharedInstance)
        }
    }
}
