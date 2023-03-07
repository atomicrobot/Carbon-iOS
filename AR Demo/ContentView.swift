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
                    RepoList(
                        onLoad: model.loadRepositories,
                        localizer: Localizers.repositoriesListLocalizer(_:)
                    )
                    .navigationDestination(for: ARRepoViews.self) { view in
                        switch view {
                        case .commitsList(let path):
                            RepoCommits(
                                urlPath: path,
                                onLoad: model.loadCommits(urlPath:),
                                localizer: Localizers.commitsListLocalizer(_:)
                            )
                            
                        case .commitDetail(let path):
                            RepoCommitDetail(
                                urlPath: path,
                                localizer: Localizers.commitDetailViewLocalizer(_:),
                                onLoad: model.loadCommit(urlPath:)
                            )
                        }
                    }
                }
                
                if model.state == .busy {
                    LoaderHUD(localizer: Localizers.loaderLocalizer(_:))
                }
            }
            .tabItem {
                Image(systemName: "server.rack")
                Text.localized(for: "tab_main")
            }
            
            VStack {
                AppInfo(item: AppInfoItem(
                    appName: Config.appName,
                    appVersion: Config.versionInfo,
                    bundleID: Config.bundleId
                ))
            }
            .tabItem {
                Image(systemName: "info.circle")
                Text.localized(for: "tab_info")
            }
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
        
        func loadCommit(urlPath: String) async throws -> CommitDetailItem {
            try await appManager.performRequest(
                request: appManager.commitRequest(for: urlPath),
                mapper: NetworkUtils.mapResults
            )
            .map(CommitDetailItem.init)
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
            message: commit.commit.message,
            urlPath: commit.commit.url
        )
    }
}

private extension CommitDetails {
    func map<T>(_ transform: (Self) -> T) -> T {
        transform(self)
    }
}

private extension CommitDetailItem {
    init(
        commitDetails: CommitDetails
    )
    {
        self.init(
            author: commitDetails.committer.name,
            date: commitDetails.committer.date,
            message: commitDetails.message,
            sha: commitDetails.sha ?? ""
        )
    }
}
