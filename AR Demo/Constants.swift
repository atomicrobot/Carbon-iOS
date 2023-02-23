import Foundation

/// A struct to hold any constants that will be used throughout the app
struct Constants {
    static let gitHubOrganization = "atomicrobot"

    /// Constants related to building API requests
    struct API {
        /// The base URL for building our API requests
        static let url = "https://api.github.com"

        /// HTTP header so we only get v3 of the API
        static let acceptHeader = "application/vnd.github.v3+json"

        /// Requesting the list of repositories for an organization
        static let repos = "/orgs/%@/repos" 
    }
}
