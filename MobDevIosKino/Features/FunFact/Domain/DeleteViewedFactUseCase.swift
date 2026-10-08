protocol DeleteViewedFactUseCase {
    func execute(
        filmId: Int,
        text: String
    ) async throws
}

final class DeleteViewedFactUseCaseImpl: DeleteViewedFactUseCase {
    private let repository: ViewedFunFactRepository

    init(repository: ViewedFunFactRepository) {
        self.repository = repository
    }

    func execute(
        filmId: Int,
        text: String
    ) async throws {
        try await repository.deleteViewedFact(
            filmId: filmId,
            text: text
        )
    }
}
