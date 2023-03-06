import Foundation

/// Custom JSONDecoder that sets some decoding strategy properties that we'll need for decoding responses from the
/// GitHub API.
class GitHubApiJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .iso8601
    }
}
