//
//  RequestType.swift
//
//
//  Created by Jonathan Lepolt on 2/6/23.
//


import Foundation

// MARK: - RequestMethod

/// HTTP method
enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
}

// MARK: - RequestError

/// Describes some error with our request
enum RequestError: Error {
    case general
    case invalidUrl
    case unknownUrl
    case jsonSerialization
    case authentication
}

// MARK: - RequestType

/// Request types used in the app
public enum RequestType {
    case repositoryList(organization: String)
    case commitsList(commitsUrl: String)
    case commitDetails(commitUrl: String)

    /// The HTTP method for this request
    var httpMethod: RequestMethod {
        switch self {
        case .repositoryList:
            return .get
        case .commitsList:
            return .get
        case .commitDetails:
            return .get
        }
    }

    /// The body params to send for this request
    private var bodyParameters: [String: Any]? {
        switch self {
        case .repositoryList:
            return nil
        case .commitsList:
            return nil
        case .commitDetails:
            return nil
        }
    }

    /// Builds a `URLRequest` for this request type
    /// - Returns: `URLRequest`
    var request: URLRequest {
        get throws {
            var url = baseUrl

            switch self {
            case .repositoryList(let organization):
                // <base_url>/orgs/<organization>/repos
                url?.append(components: "orgs", organization, "repos")
            case .commitsList(let commitsUrl):
                // commitsUrl is something like <base_url>/repos/<organization>/<repository>/commits{/sha}

                // Remove the "{sha}" portion of the commits_url from our repository list response (dunno why they include this)
                url = cleanUrl(commitsUrl)
            case .commitDetails(let commitUrl):
                // <base_url>/repos/<organization>/<repository>/git/commits/<sha>"
                url = URL(string: commitUrl)
            }

            var request = try buildBaseRequest(for: url)

            if let bodyParameters {
                guard let data = try? JSONSerialization.data(withJSONObject: bodyParameters) else { throw RequestError.jsonSerialization }

                request.httpBody = data
            }

            return request
        }
    }

    /// Builds the base URL, including the url string
    /// - Returns: `URL?`
    private var baseUrl: URL? {
        let str = "https://\(Config.baseUrl)"
        return URL(string: str)
    }

    // MARK: - Private functions

    /// Builds
    /// - Parameters:
    ///   - url: `URL?`
    /// - Returns: `URLRequest`
    private func buildBaseRequest(for url: URL?) throws -> URLRequest {
        guard let url else { throw RequestError.invalidUrl }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)

        // Add headers
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")

        request.httpMethod = httpMethod.rawValue

        switch httpMethod {
        case .get:
            break
        case .post, .patch:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    /// "Cleans" a GitHub URL by removing the string '{/sha}' from a url (I dunno why they add this)
    /// - Parameter url: The URL to clean
    /// - Returns: A new `URL?`
    private func cleanUrl(_ url: String) -> URL? {
        let strNewUrl = url.replacingOccurrences(of: "{/sha}", with: "")
        return URL(string: strNewUrl)
    }
}
