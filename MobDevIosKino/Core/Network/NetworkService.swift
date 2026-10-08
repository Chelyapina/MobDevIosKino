import Foundation

enum Endpoint {
    case films
    case filmFacts(id: Int)
    case exactFilm(id: Int)

    var path: String {
        switch self {
        case .films: return "/api/v2.2/films"
        case .filmFacts(let id): return "/api/v2.2/films/\(id)/facts"
        case .exactFilm(let id): return "/api/v2.2/films/\(id)"
        }
    }

    var url: URL? {
        URL(string: AppConfig.baseURL + path)
    }
}

protocol NetworkService {
    func request<T: Decodable>(endpoint : Endpoint)
    async throws -> T
}
