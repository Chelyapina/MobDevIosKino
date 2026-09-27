import Foundation

enum Endpoint {
    case films
    case filmFacts(id: Int)

    private var baseURL: String {
        "https://kinopoiskapiunofficial.tech"
    }

    var path: String {
        switch self {   // проверка текущего значения экземпляра
        case .films:
            return "/api/v2.2/films"

        case .filmFacts(let id):
            return "/api/v2.2/films/\(id)/facts"
        }
    }

    var url: URL? {
        URL(string: baseURL + path)
    }
}

protocol NetworkService {
    func request<T: Decodable>(endpoint : Endpoint)
    async throws -> T
}
