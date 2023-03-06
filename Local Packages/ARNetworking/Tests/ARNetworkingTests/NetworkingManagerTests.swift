import XCTest
import ARNetworking

final class NetworkingManagerTests: XCTestCase {
    var networkingManager: ARNetworkingProtocol!

    static var repositoryListMapper: (Result<Data, Error>) throws -> [Repository] = { result in
        return try TestJSONDecoder().decode([Repository].self, from: result.get())
    }

    static func mapResults<T: Decodable>(input: Result<Data, Error>) throws -> T {
        return try TestJSONDecoder().decode(T.self, from: input.get())
    }

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        networkingManager = ARNetworkingManager(urlSession: urlSession)
    }

    override func tearDown() {
        MockURLProtocol.requestErrorMode = .success
        networkingManager = nil
    }

    func testFetchRepositoriesSuccessWithMapper() async throws {
        MockURLProtocol.requestErrorMode = .success
        var fetchRepositoriesRequest = networkingManager.prepareFetchRespositories(forOrganization: "atomicrobot", toType: [Repository].self)
        var repositories: [Repository]? = try await fetchRepositoriesRequest(NetworkingManagerTests.repositoryListMapper)

        XCTAssertEqual(1, repositories?.count)

        MockURLProtocol.requestErrorMode = .fourHundred
        fetchRepositoriesRequest = networkingManager.prepareFetchRespositories(forOrganization: "atomicrobot", toType: [Repository].self)
        repositories = try? await fetchRepositoriesRequest(NetworkingManagerTests.repositoryListMapper)

        XCTAssertNil(repositories)

        MockURLProtocol.requestErrorMode = .success
        repositories = try? await fetchRepositoriesRequest(NetworkingManagerTests.mapResults)
        XCTAssertEqual(1, repositories?.count)

    }

    func testFetchRepositoriesSuccess() async throws {
        MockURLProtocol.requestErrorMode = .success
        let result = await networkingManager.fetchRepositories(gitHubOrganization: "atomicrobot")

        switch result {
        case .success(let data):
            let repositories = try TestJSONDecoder().decode([Repository].self, from: data)
            XCTAssertEqual(1, repositories.count)
        case .failure:
            XCTFail()
        }
    }

    func testFetchRepositoriesInvalidData() async throws {
        MockURLProtocol.requestErrorMode = .invalidData
        let result = await networkingManager.fetchRepositories(gitHubOrganization: "atomicrobot")

        switch result {
        case .success(let data):
            let repositories = try? TestJSONDecoder().decode([Repository].self, from: data)
            XCTAssertNil(repositories)
        case .failure:
            XCTFail("Expected success response, but with bad `Data`")
        }
    }

    func testFetchRepositoriesError300() async throws {
        MockURLProtocol.requestErrorMode = .threeHundred
        let result = await networkingManager.fetchRepositories(gitHubOrganization: "atomicrobot")

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure:
            XCTFail("Expected a success response")
        }
    }

    func testFetchRepositoriesError400() async throws {
        MockURLProtocol.requestErrorMode = .fourHundred
        let result = await networkingManager.fetchRepositories(gitHubOrganization: "atomicrobot")

        switch result {
        case .success:
            XCTFail("Did not expect a valid response")
        case .failure:
            XCTAssert(true)
        }
    }

    func testFetchRepositoriesError500() async throws {
        MockURLProtocol.requestErrorMode = .fiveHundred
        let result = await networkingManager.fetchRepositories(gitHubOrganization: "atomicrobot")

        switch result {
        case .success:
            XCTFail("Did not expect a valid response")
        case .failure:
            XCTAssert(true)
        }
    }

    func testFetchCommitsListSuccess() async throws {
        MockURLProtocol.requestErrorMode = .success
        let result = await networkingManager.fetchCommits(commitsUrl: "https://api.github.com/repos/atomicrobot/Carbon-Android/commits")

        switch result {
        case .success(let data):
            let commits = try TestJSONDecoder().decode([Commit].self, from: data)
            XCTAssertEqual(1, commits.count)
        case .failure:
            XCTFail()
        }
    }

    func testFetchCommitDetailsSuccess() async throws {
        MockURLProtocol.requestErrorMode = .success
        let result = await networkingManager.fetchCommitDetails(commitUrl: "https://api.github.com/repos/atomicrobot/CarbonAndroid/git/commits/thisisafakecommit")

        switch result {
        case .success(let data):
            let commit = try TestJSONDecoder().decode(CommitDetails.self, from: data)
            XCTAssertNotNil(commit)
        case .failure:
            XCTFail()
        }
    }

}

class TestJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .iso8601
    }
}

// MARK: - Models for testing
// The following are duplicated from the main app

/// A GitHub `Repository` model. This model is not inclusive of all the properties returned for this object.
/// For additional documentation, see: https://docs.github.com/en/rest/reference/repos
struct Repository: Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let `private`: Bool
    public let htmlUrl: String
    public let description: String?
    public let fork: Bool
    public let url: String
    public let commitsUrl: String
    public let visibility: String? // "public" or "private" or maybe "internal"

    public var isPrivate: Bool { `private` }
}

/// A GitHub `Commit` model. This object isn't very well-documented, so I kinda had to make it up and it
/// doesn't seem to align with objects defined in the GitHub docs.
/// Additional documentation: https://docs.github.com/en/rest/reference/repos#commits
struct Commit: Identifiable, Decodable {
    var id: String { sha }

    let sha: String
//    let commit: CommitDetails
//    let author: Collaborator?
//    let committer: Collaborator?
}

/// A GitHub `CommitDetails` model. This model is not inclusive of all the properties returned for this object.
/// Additionally, the GitHub documentation leaves much to be desired when it comes to specifying what some of these
/// properties mean, and whether or not they can be nil, or even if values will be returned at all.
/// For additional documentation, see: https://docs.github.com/en/rest/reference/repos#commits
struct CommitDetails: Decodable {
    let sha: String?
    let url: String
    let htmlUrl: String?
//    let author: CollaboratorStub
//    let committer: CollaboratorStub
    let message: String
}
