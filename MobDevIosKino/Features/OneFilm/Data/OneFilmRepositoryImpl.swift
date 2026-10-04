import Foundation

final class OneFilmRepositoryImpl: OneFilmRepository {
    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func getAllInfo(filmId id: Int) async throws -> OneFilmModel { //filmId - имя при вызове, id - имя внутри функции
        let dto: OneFilmDTO = try await service.request(
            endpoint: .exactFilm(id: id)
        )
        return OneFilmModel(
                id: dto.kinopoiskId,
                title: dto.nameRu ?? dto.nameOriginal ?? "Без названия",
                originalTitle: dto.nameOriginal,
                posterURL: dto.posterUrl ?? "",
                year: dto.year,
                description: dto.description,
                filmLength: dto.filmLength,
                kinopoiskRating: dto.ratingKinopoisk,
                imdbRating: dto.ratingImdb,
                countries: dto.countries.map { $0.country },
                genres: dto.genres.map { $0.genre },
                ageLimit: dto.ratingAgeLimits
            )
        }
    }
