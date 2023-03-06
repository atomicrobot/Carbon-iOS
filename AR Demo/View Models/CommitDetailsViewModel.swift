import ARNetworking
import Foundation

@MainActor
final class CommitDetailsViewModel: ObservableObject {
    @Published var commit: CommitDetails?
    @Published var showError = false

    private let appManager: AppManagerProtocol
    private let networkingManager: ARNetworkingProtocol

    var error: Error? {
        didSet {
            showError = error != nil
        }
    }

    init(commit: Commit,
         appManager: AppManagerProtocol = AppManager.sharedInstance,
         networkingManager: ARNetworkingProtocol = ARNetworkingManager.sharedInstance) {
        self.appManager = appManager
        self.networkingManager = networkingManager

        fetchDetails(for: commit)
    }
}

// MARK: - Helpers
extension CommitDetailsViewModel {
    /// Fetches details for a given commit.
    /// - Parameter commit: The `Commit`
    private func fetchDetails(for commit: Commit) {
        let request = networkingManager.prepareFetchCommitDetails(with: commit.commit.url, toType: CommitDetails.self)
        Task {
            do {
                appManager.updateLoading(true)
                let commitDetails = try await request(NetworkUtils.mapResults)
                appManager.updateLoading(false)

                self.commit = commitDetails
            } catch {
                appManager.updateLoading(false)

                self.error = error
            }
        }
    }
}
