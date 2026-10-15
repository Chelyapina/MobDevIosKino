import Foundation

protocol GetFilmListUseCase {
    func execute(filters: FilmFilters) async throws -> FilmPage
}

final class GetFilmListUseCaseImpl: GetFilmListUseCase {
    private let repository: FilmListRepository

    init(repository: FilmListRepository) {
        self.repository = repository
    }

    func execute(filters: FilmFilters) async throws -> FilmPage {
        try await repository.fetchFilms(filters: filters)
    }
}
