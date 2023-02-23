import Foundation

/// A GitHub `Collaborator` model. This model is not inclusive of all the properties returned for this object.
/// For additional documentation, see: https://docs.github.com/en/rest/reference/repos#collaborators
struct Collaborator: Identifiable, Decodable {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
}
