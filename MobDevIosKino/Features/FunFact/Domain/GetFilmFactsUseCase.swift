import Foundation

protocol GetFilmFactsUseCase {
    func getFacts(filmId: Int) async throws -> [FunFactModel]
}


final class GetFilmFactsUseCaseImpl: GetFilmFactsUseCase {
    private let repository: FilmFactsRepository

    init(repository: FilmFactsRepository) {
        self.repository = repository
    }

    func getFacts(filmId: Int) async throws -> [FunFactModel] {
        try await repository.getFacts(filmId: filmId)
    }
}

