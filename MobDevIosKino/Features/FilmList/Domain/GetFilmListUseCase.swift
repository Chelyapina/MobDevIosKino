import Foundation

protocol GetFilmListUseCase {
    func execute() async throws -> [FilmListModel]
}

final class GetFilmListUseCaseImpl: GetFilmListUseCase {
    private let repository: FilmListRepository

    init(repository: FilmListRepository) {
        self.repository = repository
    }

    func execute() async throws -> [FilmListModel] {
        try await repository.fetchFilms()
    }
}
