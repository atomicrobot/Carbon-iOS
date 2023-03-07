import ARNetworking
import Foundation

class CommitDetailsViewModel: ObservableObject {
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
                appManager.send(state: .busy)
                let commitDetails = try await request(NetworkUtils.mapResults)
                appManager.send(state: .idle)

                DispatchQueue.main.async { [weak self] in
                    self?.commit = commitDetails
                }
            } catch {
                appManager.send(state: .idle)

                DispatchQueue.main.async { [weak self] in
                    self?.error = error
                }
            }
        }
    }
}
