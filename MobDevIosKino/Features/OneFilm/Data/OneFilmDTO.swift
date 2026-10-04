import Foundation

struct OneFilmDTO: Decodable {
    let kinopoiskId: Int
    let nameRu: String?
    let nameOriginal: String?
    let posterUrl: String?
    let year: Int?
    let description: String?
    let filmLength: Int?
    let ratingKinopoisk: Double?
    let ratingImdb: Double?
    let countries: [CountryDTO]
    let genres: [GenreDTO]
    let ratingAgeLimits: String?
}
