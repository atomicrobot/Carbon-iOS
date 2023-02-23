
import Foundation

struct NetworkUtils {
    /// Checks the response of an HTTP request and makes sure it was successful.
    /// - Parameters:
    ///   - data: `Data` in the response
    ///   - response: The `URLResponse`
    /// - Returns: The `Data` for a successful network request. Otherwise throws
    static func checkResponse(_ data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else { throw URLError(.badServerResponse) }
        return data
    }

    /// Uses our custom `GitHubApiJSONDecoder` and maps a `Data` result to a specified type `T`
    /// - Parameter input: `Result` from a network request
    /// - Returns: `T`
    static func mapResults<T: Decodable>(input: Result<Data, Error>) throws -> T {
        return try GitHubApiJSONDecoder().decode(T.self, from: input.get())
    }
}
