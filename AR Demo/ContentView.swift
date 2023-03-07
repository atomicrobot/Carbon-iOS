import ARDemoUI
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        ZStack {
            if appManager.isLoading {
                LoaderHUD(localizer: loaderLocalizer(_:))
                    .zIndex(1)
            }

            TabView {
                NavigationView {
                    RepositoryListView()
                }
                .tabItem {
                    Image(systemName: "server.rack")
                    Text.localized(for: "tab_main")
                }

                VStack {
                    InfoView()
                }
                .tabItem {
                    Image(systemName: "info.circle")
                    Text.localized(for: "tab_info")
                }
            }
        }
    }
}

extension ContentView {
    private func loaderLocalizer(_ key: LoaderHUD.Key) -> String {
        switch key {
        case .title:
            return NSLocalizedString(
                "loading",
                comment: "Loading HUD"
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppManager.sharedInstance)
    }
}
