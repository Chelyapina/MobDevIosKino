import Foundation

extension CachedFilm {
    func toDomain() -> FilmListModel {
        FilmListModel(
            id: id,
            title: title,
            originalTitle: originalTitle,
            year: year,
            rating: rating,
            genres: genres,
            posterURL: posterURL
        )
    }

    convenience init(from model: FilmListModel) {
        self.init(
            id: model.id,
            title: model.title,
            originalTitle: model.originalTitle,
            year: model.year,
            rating: model.rating,
            genres: model.genres,
            posterURL: model.posterURL
        )
    }
}
