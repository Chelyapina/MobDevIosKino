import Foundation

protocol GetOneFilmUseCase {
    func getFilm(filmId: Int) async throws -> OneFilmModel
}


final class GetOneFilmUseCaseImpl: GetOneFilmUseCase {
    private let repository: OneFilmRepository

    init(repository: OneFilmRepository) {
        self.repository = repository
    }

    func getFilm(filmId: Int) async throws -> OneFilmModel {
        try await repository.getAllInfo(filmId: filmId)
    }
}

