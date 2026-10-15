import Foundation

struct SearchFilmsResponseDTO: Decodable {
    let keyword: String
    let pagesCount: Int
    let searchFilmsCountResult: Int
    let films: [SearchFilmDTO]
}

struct SearchFilmDTO: Decodable {
    let filmId: Int
    let nameRu: String?
    let nameEn: String?
    let type: String
    let year: String?
    let description: String?
    let posterUrlPreview: String?
}
