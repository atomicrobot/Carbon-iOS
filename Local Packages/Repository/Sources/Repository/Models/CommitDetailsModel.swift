import Foundation

/// A GitHub `CommitDetails` model. This model is not inclusive of all the properties returned for this object.
/// Additionally, the GitHub documentation leaves much to be desired when it comes to specifying what some of these
/// properties mean, and whether or not they can be nil, or even if values will be returned at all.
/// For additional documentation, see: https://docs.github.com/en/rest/reference/repos#commits
struct CommitDetails: Decodable {
    let sha: String?
    let url: String
    let htmlUrl: String?
    let author: CollaboratorStub
    let committer: CollaboratorStub
    let message: String
}
