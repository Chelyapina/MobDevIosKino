import Foundation

enum Endpoint {
    case films
    case filmFacts(id: Int)
    case exactFilm(id: Int)
    case searchFilms(keyword: String, page: Int)

    var path: String {
        switch self {
        case .films: return "/api/v2.2/films"
        case .filmFacts(let id): return "/api/v2.2/films/\(id)/facts"
        case .exactFilm(let id): return "/api/v2.2/films/\(id)"
        case .searchFilms: return "/api/v2.1/films/search-by-keyword"
        }
    }

    var queryItems: [URLQueryItem] {
            switch self {
            case .searchFilms(let keyword, let page):
                return [
                    URLQueryItem(name: "keyword", value: keyword),
                    URLQueryItem(name: "page", value: String(page))
                ]
            default:
                return []
        }
    }

    var url: URL? {
        var components = URLComponents(string: AppConfig.baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
}

protocol NetworkService {
    func request<T: Decodable>(endpoint : Endpoint)
    async throws -> T
}
