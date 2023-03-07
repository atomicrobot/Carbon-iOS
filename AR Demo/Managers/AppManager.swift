import ARNetworking
import Combine
import Foundation

/// For testing purposes, this is a protocol. You can mock your own class and inject it into classes that require it.
protocol AppManagerProtocol {
    /// Tracks the current loading state across the app
    var state: AppManager.State { get }
    
    /// A method to publish the state of the `AppManager`
    func send(state: AppManager.State)
}

/// A manager to track some overall state of the app. For now it's just holding onto the the `isLoading` state
/// This is a singleton, and should be accessed with `AppManager.sharedInstance`
class AppManager: AppManagerProtocol, ObservableObject {
    enum State {
        case busy
        case idle
    }
    
    /// Shared instance of this AppManager singleton
    static let sharedInstance = AppManager()

    // Private so we only init once
    private init(
        networkManager: ARNetworkingProtocol = ARNetworkingManager.sharedInstance
    )
    {
        self.networkManager = networkManager
        
        stateQueue
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
    private var networkManager: ARNetworkingProtocol
    private var stateQueue = PassthroughSubject<State, Never>()

    @Published var state: State = .idle
    
    func send(state: State) {
        stateQueue.send(state)
    }
    
    func performRequest<T>(
        request: ((Result<Data, Error>) throws -> T) async throws -> T,
        mapper: @escaping (Result<Data, Error>) throws -> T
    ) async throws -> T
    {
        send(state: .busy)
        let result = try await request(mapper)
        send(state: .idle)
        return result
    }
}

extension AppManager {
    var repoRequest: ((Result<Data, Error>) throws -> [Repository]) async throws -> [Repository] {
        networkManager.prepareFetchRespositories(
            forOrganization: Constants.gitHubOrganization,
            toType: [Repository].self
        )
    }
}
