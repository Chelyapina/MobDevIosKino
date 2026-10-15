import Foundation
import OSLog

final class NetworkServiceImpl : NetworkService { // final = класс без наследования
    private let session: URLSession
    private let apiKey: String
    private static let logger = Logger(subsystem: "network", category: "service")
    private static let decoder = JSONDecoder()
    
    init(session: URLSession = .shared, apiKey: String
    ) {
        self.session = session
        self.apiKey = apiKey
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
            print(endpoint.url?.absoluteString ?? "nil")
        } catch {
            NetworkServiceImpl.logger.error("Request failed: \(error.localizedDescription)")
            throw NetworkError.noConnection
        }

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        guard 200..<300 ~= http.statusCode else {
            throw NetworkError.server(statusCode: http.statusCode)
        }

        do {
            return try Self.decoder.decode(T.self, from: data)
        } catch {
            NetworkServiceImpl.logger.error("Decoding failed: \(error)")
            throw NetworkError.decoding
        }
    }
}
