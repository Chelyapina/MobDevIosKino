import Foundation
import OSLog

final class NetworkServiceImpl : NetworkService { // final = класс без наследования
    private let session: URLSession
    private let apiKey: String
    private static let logger = Logger(subsystem: "network", category: "service")
    private static let decoder = JSONDecoder()
    
    init(session: URLSession = .shared, apiKey: String
    ) {
        self.session = session  // по умолчанию
        self.apiKey = apiKey
    }
    
    // универсальный метод для получения ответа и декодирования
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        
        // ТЕСТ: имитируем отсутствие интернета
        //throw NetworkError.noConnection
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
            print(endpoint.url?.absoluteString ?? "nil")
        } catch let error as URLError {
            // Обрабатываем сетевые ошибки URLSession
            Self.logger.error("Network error: \(error.localizedDescription)")
            
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noConnection
                
            case .timedOut:
                throw NetworkError.timeout
                
            default:
                throw NetworkError.unknown
            }
        } catch {
            // Обрабатываем остальные непредвиденные ошибки
            Self.logger.error("Unexpected error: \(error.localizedDescription)")
            throw NetworkError.unknown
        }
        
        // проверка на соответствие протоколу http
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        // Успешные HTTP-коды: 200–299.
        // Остальные передаём в NetworkError вместе с кодом.
        guard (200...299).contains(http.statusCode) else {
            Self.logger.error("HTTP error: \(http.statusCode)")
            throw NetworkError.server(statusCode: http.statusCode)
        }
        
        
        // JSON из Data в Swift-модель типа T
        do {
            return try Self.decoder.decode(T.self, from: data)

        } catch DecodingError.keyNotFound(let key, _) {
            // В JSON отсутствует обязательное поле
            Self.logger.error("Missing JSON key: \(key.stringValue)")
            throw NetworkError.decoding

        } catch DecodingError.typeMismatch(let type, let context) {
            // Тип значения в JSON не соответствует типу в DTO
            Self.logger.error(
                "Type mismatch: expected \(String(describing: type)), \(context.debugDescription)"
            )
            throw NetworkError.decoding

        } catch {
            // остальные ошибки декодирования
            Self.logger.error("Decoding failed: \(error)")
            throw NetworkError.decoding
        }

    }
}
