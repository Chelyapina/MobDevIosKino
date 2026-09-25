import Foundation

extension FilmListDTO {
    func toDomain() -> FilmListModel {
        FilmListModel(
            id: kinopoiskId,
            title: nameRu ?? nameEn ?? nameOriginal ?? "Без названия",
            originalTitle: nameOriginal,
            year: year,
            rating: ratingKinopoisk,
            genres: genres.map(\.genre),
            posterURL: URL(string: posterUrlPreview)
        )
    }
}

extension FilmListResponseDTO {
    func toDomain() -> [FilmListModel] {
        items.map { $0.toDomain() }
    }
}
