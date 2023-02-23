import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        ZStack {
            if appManager.isLoading {
                LoaderHUDView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
