import Foundation

protocol FilmListServiceProtocol {
    func getFilms() async throws -> FilmListResponseDTO
}

final class MockFilmListService: FilmListServiceProtocol {
    func getFilms() async throws -> FilmListResponseDTO {
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        return FilmListResponseDTO(
            total: 4,
            totalPages: 1,
            items: Self.mockItems
        )
    }
}

private extension MockFilmListService {
    static let mockItems: [FilmListDTO] = [
        FilmListDTO(
            kinopoiskId: 263531, imdbId: "tt0050561",
            nameRu: "Мстители", nameEn: "The Avengers", nameOriginal: "The Avengers",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "фантастика")],
            ratingKinopoisk: 7.9, ratingImdb: 7.9, year: 2012, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/263531.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/263531.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 326, imdbId: "tt0111161",
            nameRu: "Побег из Шоушенка", nameEn: "The Shawshank Redemption", nameOriginal: "The Shawshank Redemption",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "драма")],
            ratingKinopoisk: 9.1, ratingImdb: 9.3, year: 1994, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/326.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/326.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 447301, imdbId: "tt1375666",
            nameRu: "Начало", nameEn: "Inception", nameOriginal: "Inception",
            countries: [CountryDTO(country: "США"), CountryDTO(country: "Великобритания")],
            genres: [GenreDTO(genre: "фантастика"), GenreDTO(genre: "боевик"), GenreDTO(genre: "триллер")],
            ratingKinopoisk: 8.7, ratingImdb: 8.8, year: 2010, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/447301.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/447301.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 258687, imdbId: "tt0816692",
            nameRu: "Интерстеллар", nameEn: "Interstellar", nameOriginal: "Interstellar",
            countries: [CountryDTO(country: "США"), CountryDTO(country: "Великобритания")],
            genres: [GenreDTO(genre: "фантастика"), GenreDTO(genre: "драма"), GenreDTO(genre: "приключения")],
            ratingKinopoisk: 8.6, ratingImdb: 8.7, year: 2014, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/258687.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/258687.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 464963, imdbId: "tt0110413",
            nameRu: "Леон", nameEn: "Léon: The Professional", nameOriginal: "Léon",
            countries: [CountryDTO(country: "Франция")],
            genres: [GenreDTO(genre: "драма"), GenreDTO(genre: "боевик"), GenreDTO(genre: "криминал")],
            ratingKinopoisk: 8.6, ratingImdb: 8.5, year: 1994, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/464963.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/464963.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 32898, imdbId: "tt0137523",
            nameRu: "Бойцовский клуб", nameEn: "Fight Club", nameOriginal: "Fight Club",
            countries: [CountryDTO(country: "США"), CountryDTO(country: "Германия")],
            genres: [GenreDTO(genre: "триллер"), GenreDTO(genre: "драма")],
            ratingKinopoisk: 8.7, ratingImdb: 8.8, year: 1999, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/32898.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/32898.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 361, imdbId: "tt0068646",
            nameRu: "Крёстный отец", nameEn: "The Godfather", nameOriginal: "The Godfather",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "драма"), GenreDTO(genre: "криминал")],
            ratingKinopoisk: 9.2, ratingImdb: 9.2, year: 1972, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/361.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/361.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 372, imdbId: "tt0102926",
            nameRu: "Молчание ягнят", nameEn: "The Silence of the Lambs", nameOriginal: "The Silence of the Lambs",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "триллер"), GenreDTO(genre: "детектив")],
            ratingKinopoisk: 8.2, ratingImdb: 8.6, year: 1990, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/372.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/372.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 448, imdbId: "tt0099685",
            nameRu: "Криминальное чтиво", nameEn: "Pulp Fiction", nameOriginal: "Pulp Fiction",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "криминал"), GenreDTO(genre: "драма")],
            ratingKinopoisk: 8.6, ratingImdb: 8.9, year: 1994, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/448.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/448.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 389, imdbId: "tt0071562",
            nameRu: "Крёстный отец 2", nameEn: "The Godfather Part II", nameOriginal: "The Godfather Part II",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "драма"), GenreDTO(genre: "криминал")],
            ratingKinopoisk: 8.8, ratingImdb: 9.0, year: 1974, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/389.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/389.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 349, imdbId: "tt0088763",
            nameRu: "Назад в будущее", nameEn: "Back to the Future", nameOriginal: "Back to the Future",
            countries: [CountryDTO(country: "США")],
            genres: [GenreDTO(genre: "фантастика"), GenreDTO(genre: "комедия"), GenreDTO(genre: "приключения")],
            ratingKinopoisk: 8.7, ratingImdb: 8.5, year: 1985, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/349.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/349.jpg"
        ),
        FilmListDTO(
            kinopoiskId: 476, imdbId: "tt0088247",
            nameRu: "Терминатор", nameEn: "The Terminator", nameOriginal: "The Terminator",
            countries: [CountryDTO(country: "США"), CountryDTO(country: "Великобритания")],
            genres: [GenreDTO(genre: "фантастика"), GenreDTO(genre: "боевик")],
            ratingKinopoisk: 8.1, ratingImdb: 8.1, year: 1984, type: "FILM",
            posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/476.jpg",
            posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/476.jpg"
        )
    ]
}
