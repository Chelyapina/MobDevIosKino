struct OneFilmModel: Equatable {
    let id: Int
    let title: String
    let originalTitle: String?
    let posterURL: String
    let year: Int?
    let description: String?
    let filmLength: Int?
    let kinopoiskRating: Double?
    let imdbRating: Double?
    let countries: [String]
    let genres: [String]
    let ageLimit: String?
}
