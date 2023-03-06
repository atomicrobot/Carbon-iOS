
import Combine
import Foundation

/// For testing purposes, this is a protocol. You can mock your own class and inject it into classes that require it.
public protocol AppManagerProtocol {
    /// Tracks the current loading state across the app
    var isLoading: Bool { get }

    /// Updates the loading state of things happening in the app
    /// - Parameter isLoading: Bool
    func updateLoading(_ isLoading: Bool)
}

/// A manager to track some overall state of the app. For now it's just holding onto the the `isLoading` state
/// This is a singleton, and should be accessed with `AppManager.sharedInstance`
public class AppManager: AppManagerProtocol, ObservableObject {
    /// Shared instance of this AppManager singleton
    public static let sharedInstance = AppManager()

    // Private so we only init once
    private init() {}

    @Published public var isLoading = false

    public func updateLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = isLoading
        }
    }
}
