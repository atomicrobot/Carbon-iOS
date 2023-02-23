//
//  MockURLProtocol.swift
//  
//
//  Created by Jonathan Lepolt on 2/7/23.
//

import Foundation
@testable import ARNetworking


// MARK: - RequestErrorMode

/// Defines the type of response to set for our mock protocol.
enum RequestErrorMode {
    /// Successful response (ie, no error and good data)
    case success

    /// Successful (200) response, but unexpected `Data` that can't be decoded correctly
    case invalidData

    /// 300 response
    case threeHundred

    /// 400 response
    case fourHundred

    /// 500 response
    case fiveHundred
}

// MARK: - MockURLProtocol

// Heavily inspired from https://medium.com/@dhawaldawar/how-to-mock-urlsession-using-urlprotocol-8b74f389a67a
class MockURLProtocol: URLProtocol {
    static let mockResponsesDirectory = "Mock Responses"

    /// The current `RequestErrorMode`
    static var requestErrorMode: RequestErrorMode = .success

    // Handler to test the request and return mock response.
    static private var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)

        setupRequestHandlers()
    }

    override class func canInit(with request: URLRequest) -> Bool {
        // To check if this protocol can handle the given request.
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Here you return the canonical version of the request but most of the time you pass the orignal one.
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)

            // 3. Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
                // 4. Send received data to the client.
                client?.urlProtocol(self, didLoad: data)
            }

            // 5. Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // 6. Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}

// MARK: - MockURLProtocol extensions

extension MockURLProtocol {
    /// Sets up our `requestHandler` to handle all the expected request types and return the correct responses
    private func setupRequestHandlers() {
        switch MockURLProtocol.requestErrorMode {
        case .success:
            setupSuccessResponse()
        case .invalidData:
            setupInvalidDataResponse()
        case .threeHundred:
            setupErrorResponse(statusCode: 300)
        case .fourHundred:
            setupErrorResponse(statusCode: 400)
        case .fiveHundred:
            setupErrorResponse(statusCode: 500)
        }
    }

    /// Sets up our `requestHandler` to return invalid `Data`
    private func setupInvalidDataResponse() {
        MockURLProtocol.requestHandler = { request in
            let data = Data()

            guard let url = request.url else {
                throw RequestError.invalidUrl
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }

    /// Sets up our `requestHandler` to return an error code in the response
    /// - Parameter statusCode: The Int HTTP status code
    private func setupErrorResponse(statusCode: Int) {
        MockURLProtocol.requestHandler = { request in
            let data = Data()

            guard let url = request.url else {
                throw RequestError.invalidUrl
            }

            let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }

    /// Sets up our `requestHandler` to return a successful response with good data
    private func setupSuccessResponse() {
        MockURLProtocol.requestHandler = { request in
            var data: Data?

            guard let url = request.url else {
                throw RequestError.invalidUrl
            }

            // Handle all expected URLs
            switch url.relativePath {
            case _ where url.relativePath.contains("orgs/atomicrobot/repos"):
                data = self.fetchRespositories()
            case _ where url.relativePath.contains("repos/atomicrobot/Carbon-Android/commits"):
                data = self.fetchCommits()
            case _ where url.relativePath.contains("repos/atomicrobot/CarbonAndroid/git/commits/"):
                data = self.fetchCommitDetails()
            default:
                throw RequestError.unknownUrl
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }

    /// Simulates fetching a list of repositories from the API
    /// - Returns: `Data?` if we find it
    private func fetchRespositories() -> Data? {
        // Load json string from file
        guard let fileUrl = Bundle.module.url(forResource: "repositories", withExtension: "json"),
              let jsonStr = try? String(contentsOf: fileUrl) else {
                  return nil
              }

        return jsonStr.data(using: .utf8)
    }

    private func fetchCommits() -> Data? {
        // Load json string from file
        guard let fileUrl = Bundle.module.url(forResource: "commits", withExtension: "json"),
              let jsonStr = try? String(contentsOf: fileUrl) else {
            return nil
        }

        return jsonStr.data(using: .utf8)
    }

    private func fetchCommitDetails() -> Data? {
        // Load json string from file
        guard let fileUrl = Bundle.module.url(forResource: "commit-details", withExtension: "json"),
              let jsonStr = try? String(contentsOf: fileUrl) else {
            return nil
        }

        return jsonStr.data(using: .utf8)
    }
}
