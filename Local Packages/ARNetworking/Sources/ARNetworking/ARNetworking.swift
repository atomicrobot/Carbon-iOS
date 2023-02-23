
import UIKit

// MARK: - ARNetworkingProtocol

public protocol ARNetworkingProtocol {
    /// Fetches a list of GitHub `Repository` objects for a specified organization
    /// - Parameter gitHubOrganization: String of the GitHub org we are trying to fetch from
    /// - Returns: Result<Data, Error>
    func fetchRepositories(gitHubOrganization: String) async -> Result<Data, Error>

    /// Fetches a list of GitHub commits for a specified repo URL
    /// - Parameter commitsUrl: The URL, provided by the `Respository` object
    /// - Returns: Result<Data, Error>
    func fetchCommits(commitsUrl: String) async -> Result<Data, Error>

    /// Retches the details of a commit for a specified commit URL
    /// - Parameter commitUrl: The URL, provided by the `CommitDetails` object
    /// - Returns: Result<Data, Error>
    func fetchCommitDetails(commitUrl: String) async -> Result<Data, Error>
}

// Added default implementation, here the function essentially prepares the `fetchRepositories`
// function, allowing for a mapping function to be chained down the line
public extension ARNetworkingProtocol {
    /// Prepares to perform a fetch allowing the caller to specify the type and how to map the response
    ///
    /// - parameters:
    ///  - forOganization: The name of the organization to perform the fetch for
    ///  - toType: The type of object to expected to map to
    ///  - mapping function: A function to perform the mapping of the result
    ///
    /// Calling this method in iteself does not perform the fetch but rather returns immediately
    /// allowing the caller to chain to it. Once the mapping function is provided then the method
    /// will execute the entire pipe.
    func prepareFetchRespositories<T>(forOrganization org: String, toType: T.Type) -> ((Result<Data, Error>) throws -> T) async throws -> T {
        { mapper in try await mapper(self.fetchRepositories(gitHubOrganization: org)) }
    }

    /// Prepares to perform a fetch allowing the caller to specify the type and how to map the response
    /// - Parameters:
    ///   - commitsUrl: The URL of the commits we will fetch
    ///   - toType: The type of object to expected to map to
    /// - Returns: A closure to execute the call to fetch the commits
    func prepareFetchCommits<T>(with commitsUrl: String, toType: T.Type) -> ((Result<Data, Error>) throws -> T) async throws -> T {
        { mapper in try await mapper(self.fetchCommits(commitsUrl: commitsUrl)) }
    }

    /// Prepares to perform a fetch allowing the caller to specify the type and how to map the response
    /// - Parameters:
    ///   - commitUrl: The URL of the commit we will fetch
    ///   - toType: The type of object to expected to map to
    /// - Returns: A closure to execute the call to fetch the commit
    func prepareFetchCommitDetails<T>(with commitUrl: String, toType: T.Type) -> ((Result<Data, Error>) throws -> T) async throws -> T {
        { mapper in try await mapper(self.fetchCommitDetails(commitUrl: commitUrl)) }
    }
}

// MARK: - ARNetworking

public final class ARNetworkingManager {
    /// Singleton `ARNetworkingProtocol` object to use throughout your app
    static public var sharedInstance: ARNetworkingProtocol = ARNetworkingManager()

    /// `URLSession` to use for our network requests. Injected so we can pass in a stub for testing.
    private let urlSession: URLSession

    // MARK: initialization

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

// MARK: ARNetworkingProtocol

extension ARNetworkingManager: ARNetworkingProtocol {

    public func fetchRepositories(gitHubOrganization: String) async -> Result<Data, Error> {
        let requestType = RequestType.repositoryList(organization: gitHubOrganization)

        do {
            let (data, response) = try await urlSession.data(for: requestType.request)

            if let error = ErrorManager.parseResponse(data: data, response: response) {
                return .failure(error)
            }
            return .success(data)
        } catch let error as NSError {
            return .failure(error)
        }
    }

    public func fetchCommits(commitsUrl: String) async -> Result<Data, Error> {
        let requestType = RequestType.commitsList(commitsUrl: commitsUrl)

        do {
            let (data, response) = try await urlSession.data(for: requestType.request)

            if let error = ErrorManager.parseResponse(data: data, response: response) {
                return .failure(error)
            }
            return .success(data)
        } catch let error as NSError {
            return .failure(error)
        }
    }

    public func fetchCommitDetails(commitUrl: String) async -> Result<Data, Error> {
        let requestType = RequestType.commitDetails(commitUrl: commitUrl)

        do {
            let (data, response) = try await urlSession.data(for: requestType.request)

            if let error = ErrorManager.parseResponse(data: data, response: response) {
                return .failure(error)
            }
            return .success(data)
        } catch let error as NSError {
            return .failure(error)
        }
    }
}
