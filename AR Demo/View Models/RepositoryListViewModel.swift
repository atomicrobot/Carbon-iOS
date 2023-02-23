import ARNetworking
import Foundation

class RepositoryListViewModel: ObservableObject {
    @Published var repositories = [Repository]()
    @Published var showError = false

    private let appManager: AppManagerProtocol
    private let networkingManager: ARNetworkingProtocol

    var error: Error? {
        didSet {
            showError = error != nil
        }
    }

    init(appManager: AppManagerProtocol = AppManager.sharedInstance,
         networkingManager: ARNetworkingProtocol = ARNetworkingManager.sharedInstance) {
        self.appManager = appManager
        self.networkingManager = networkingManager

        fetchData()
    }
}

// MARK: - Helpers
extension RepositoryListViewModel {
    /// A method that attempts to fetch a list of repositories for a default GitHub organization. Errors are handled.
    private func fetchData() {
        let request = networkingManager.prepareFetchRespositories(forOrganization: Constants.gitHubOrganization, toType: [Repository].self)
        Task {
            do {
                appManager.updateLoading(true)
                let repositories = try await request(NetworkUtils.mapResults)
                appManager.updateLoading(false)

                DispatchQueue.main.async { [weak self] in
                    self?.repositories = repositories
                }
            } catch let error as NSError {
                appManager.updateLoading(false)

                DispatchQueue.main.async { [weak self] in
                    self?.error = error
                }
            }
        }
    }
}
