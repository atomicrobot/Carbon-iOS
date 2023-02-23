import Foundation

/// A GitHub `CollaboratorStub` model. This object isn't very well-documented, so I kinda had to make it up and it
/// doesn't seem to align with objects defined in the GitHub docs.
struct CollaboratorStub: Decodable {
    let name: String
    let email: String
    let date: Date
}
