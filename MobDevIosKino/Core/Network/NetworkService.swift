import Foundation

enum Endpoint {
    case films(type: String?, ratingFrom: Double?, page: Int)
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
        case .films(let type, let ratingFrom, let page):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "page", value: String(page))
            ]
            if let type { items.append(.init(name: "type", value: type)) }
            if let ratingFrom { items.append(.init(name: "ratingFrom", value: String(ratingFrom))) }
            return items

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
