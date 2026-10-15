import Foundation

extension FilmListDTO {
    func toDomain() -> FilmListModel {
        FilmListModel(
            id: kinopoiskId,
            title: nameRu ?? nameEn ?? nameOriginal ?? "Без названия",
            originalTitle: nameOriginal,
            year: year,
            rating: ratingKinopoisk,
            genres: (genres ?? []).map(\.genre),
            posterURL: (posterUrlPreview ?? posterUrl).flatMap(URL.init(string:))
        )
    }
}

extension FilmListResponseDTO {
    func toDomain() -> [FilmListModel] {
        items.map { $0.toDomain() }
    }
}
