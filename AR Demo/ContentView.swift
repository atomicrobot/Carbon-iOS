import ARDemoUI
import SwiftUI

struct ContentView: View {
    init(
        appManager: AppManager
    )
    {
        self._model = StateObject(
            wrappedValue: Model(appManager: appManager))
    }
    
    @StateObject private var model: Model
    
    var body: some View {
        TabView {
            ZStack {
                NavigationStack(path: $model.views) {
                    RepositoryList(
                        onLoad: model.loadRepositories,
                        localizer: repositoriesListLocalizer(_:)
                    )
                    .navigationDestination(for: ARRepoViews.self) { view in
                        switch view {
                        case .commitsList(let path):
                            CommitsList(
                                urlPath: path,
                                onLoad: model.loadCommits(urlPath:),
                                localizer: commitsListLocalizer(_:)
                            )
                        }
                    }
                }
                
                if model.state == .busy {
                    LoaderHUD(localizer: loaderLocalizer(_:))
                }
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

// MARK: Localization
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
    
    private func repositoriesListLocalizer(_ key: RepositoryList.Key) -> String {
        switch key {
        case .errorMessage:
            return NSLocalizedString(
                "repository_list_error_description",
                comment: "Repository List Error Message"
            )
            
        case .errorOK:
            return NSLocalizedString(
                "ok",
                comment: "Repository List Error Ok Button Title"
            )
            
        case .errorTitle:
            return NSLocalizedString(
                "repository_list_error_title",
                comment: "Repository List Error Title"
            )
            
        }
    }
    
    private func commitsListLocalizer(_ key: CommitsList.Key) -> String {
        switch key {
        case .errorMessage:
            return NSLocalizedString(
                "repository_list_error_description",
                comment: "Repository List Error Message"
            )
            
        case .errorOK:
            return NSLocalizedString(
                "ok",
                comment: "Repository List Error Ok Button Title"
            )
            
        case .errorTitle:
            return NSLocalizedString(
                "repository_list_error_title",
                comment: "Repository List Error Title"
            )
            
        }
    }
}

// MARK: Models
extension ContentView {    
    final class Model: ObservableObject {
        init(
            appManager: AppManager
        )
        {
            self.appManager = appManager
            
            appManager.$state
                .receive(on: DispatchQueue.main)
                .assign(to: &$state)
        }
        
        // MARK: Properties
        let appManager: AppManager
        
        @Published var state: AppManager.State = .idle
        @Published var views: [ARRepoViews]    = []
        
        // MARK: Functions
        func loadRepositories() async throws -> [RepostioryListDataItem] {
            try await appManager.performRequest(
                request: appManager.repoRequest,
                mapper: NetworkUtils.mapResults
            )
            .map(RepostioryListDataItem.init)
        }
        
        func loadCommits(urlPath: String) async throws -> [CommitsListDataItem] {
            try await appManager.performRequest(
                request: appManager.commitsRequest(for: urlPath),
                mapper: NetworkUtils.mapResults
            )
            .map(CommitsListDataItem.init)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appManager: AppManager.sharedInstance)
    }
}

private extension RepostioryListDataItem {
    init(
        repository: Repository
    )
    {
        self.init(
            name: repository.name,
            description: repository.description,
            urlPath: repository.commitsUrl
        )
    }
}

private extension CommitsListDataItem {
    init(
        commit: Commit
    )
    {
        self.init(
            sha: commit.sha,
            message: commit.commit.message
        )
    }
}
