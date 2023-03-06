import Foundation

/// A GitHub `Commit` model. This object isn't very well-documented, so I kinda had to make it up and it
/// doesn't seem to align with objects defined in the GitHub docs.
/// Additional documentation: https://docs.github.com/en/rest/reference/repos#commits
struct Commit: Identifiable, Decodable {
    var id: String { sha }

    let sha: String
    let commit: CommitDetails
    let author: Collaborator?
    let committer: Collaborator?
}
