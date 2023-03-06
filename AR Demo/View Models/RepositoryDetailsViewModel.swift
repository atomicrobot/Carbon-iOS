import ARNetworking
import Foundation

@MainActor
class RepositoryDetailsViewModel: ObservableObject {
    @Published var commits = [Commit]()
    @Published var showError = false

    private let appManager: AppManagerProtocol
    private let networkingManager: ARNetworkingProtocol

    var error: Error? {
        didSet {
            showError = error != nil
        }
    }

    init(repository: Repository,
         appManager: AppManagerProtocol = AppManager.sharedInstance,
         networkingManager: ARNetworkingProtocol = ARNetworkingManager.sharedInstance) {
        self.appManager = appManager
        self.networkingManager = networkingManager

        fetch(for: repository)
    }
}

// MARK: - Helpers
extension RepositoryDetailsViewModel {

    /// Fetches commits for a specified Repository
    /// - Parameters:
    ///   - repository: The `Repository`
    ///   - url: The URL to fetch
    private func fetch(for repository: Repository) {
        let request = networkingManager.prepareFetchCommits(with: repository.commitsUrl, toType: [Commit].self)
        Task {
            do {
                appManager.updateLoading(true)
                let commits = try await request(NetworkUtils.mapResults)
                appManager.updateLoading(false)

                self.commits = commits
            } catch let error as NSError {
                appManager.updateLoading(false)

                self.error = error
            }
        }
    }
}
