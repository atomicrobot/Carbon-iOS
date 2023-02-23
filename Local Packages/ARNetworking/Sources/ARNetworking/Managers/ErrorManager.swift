//
//  ErrorManager.swift
//  
//
//  Created by Jonathan Lepolt on 2/6/23.
//

import Foundation

// MARK: - URLError

enum URLError: LocalizedError {
    case generalError(messages: [String])
    case httpResponseError
    case badRequest         // 400
    case unauthorized       // 401
    case forbidden          // 403
    case notFound           // 404
    case unprocessable      // 422
    case generalClient      // All other 4XX
    case generalServer      // All other 5XX
    case unknown

    /// The user-friendly-ish description of this error
    var errorDescription: String? {
        switch self {
        case .generalError(let messages):
            return messages.joined(separator: "\n")
        case .httpResponseError:
            return "Could not parse the response from the server."
        case .badRequest:
            return "Invalid data sent to server."
        case .unauthorized:
            return "Invalid username or password."
        case .forbidden:
            return "You do not have permissions to do this."
        case .notFound:
            return "This item does not exist."
        case .unprocessable:
            return "Server could not process the request."
        case .generalClient:
            return "General client error."
        case .generalServer:
            return "Server error. Try again later."
        case .unknown:
            return "Unknown error."
        }
    }
}

// MARK: - ErrorManager

// ~Heavily~ Medium inspired from https://www.ralfebert.com/swiftui/generic-error-handling/
struct ErrorManager {
    static func parseResponse(data: Data, response: URLResponse) -> Error? {
        // Check for HTTPURLResponse with a status code in the 2XXs
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return handleErrorResponse(data: data, response: response)
        }

        return nil
    }

    // MARK: - Private functions

    static private func handleErrorResponse(data: Data, response: URLResponse) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return URLError.httpResponseError
        }

        // First let's see if the server provided us an error message
        if let errorResponse = try? JSONDecoder().decode([String].self, from: data) {
            return URLError.generalError(messages: errorResponse)
        }

        var error = URLError.unknown

        // Otherwise let's do a little manual parsing on status code returned
        switch httpResponse.statusCode {
        case 300...399:
            return nil
        case 400:
            error = URLError.badRequest
        case 401:
            error = URLError.unauthorized
        case 403:
            error = URLError.forbidden
        case 404:
            error = URLError.notFound
        case 400...499:
            error = URLError.generalClient
        case 500...599:
            error = URLError.generalServer
        default:
            let msg = "Unexpected HTTP status code. Found: '\(httpResponse.statusCode)'"
            assertionFailure(msg)
        }

        return error
    }
}
