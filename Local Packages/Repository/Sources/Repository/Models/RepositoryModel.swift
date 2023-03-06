import Foundation

/// A GitHub `Repository` model. This model is not inclusive of all the properties returned for this object.
/// For additional documentation, see: https://docs.github.com/en/rest/reference/repos
struct Repository: Identifiable, Decodable {
    let id: Int
    let name: String
    let fullName: String
    let `private`: Bool
    let htmlUrl: String
    let description: String?
    let fork: Bool
    let url: String
    let commitsUrl: String
    let visibility: String? // "public" or "private" or maybe "internal"

    var isPrivate: Bool { `private` }
}
