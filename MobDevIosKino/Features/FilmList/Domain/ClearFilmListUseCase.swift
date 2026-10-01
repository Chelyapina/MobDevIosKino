import Foundation

protocol ClearFilmListUseCase {
    func execute() async throws
}

final class ClearFilmListUseCaseImpl: ClearFilmListUseCase {
    private let repository: FilmListRepository
    init(repository: FilmListRepository) { self.repository = repository }

    func execute() async throws {
        try await repository.clearCache()
    }
}
