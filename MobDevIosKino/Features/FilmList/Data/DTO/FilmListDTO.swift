import Foundation

struct FilmListResponseDTO: Decodable {
    let total: Int
    let totalPages: Int
    let items: [FilmListDTO]
}

struct FilmListDTO: Decodable {
    let kinopoiskId: Int
    let imdbId: String?
    let nameRu: String?
    let nameEn: String?
    let nameOriginal: String?
    let countries: [CountryDTO]
    let genres: [GenreDTO]
    let ratingKinopoisk: Double?
    let ratingImdb: Double?
    let year: Int?
    let type: String
    let posterUrl: String
    let posterUrlPreview: String
}

struct CountryDTO: Decodable {
    let country: String
}

struct GenreDTO: Decodable {
    let genre: String
}
