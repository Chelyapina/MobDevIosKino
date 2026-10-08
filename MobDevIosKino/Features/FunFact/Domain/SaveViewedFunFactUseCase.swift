protocol SaveViewedFunFactUseCase {
    func execute(
        filmId: Int,
        filmTitle: String,
        fact: FunFactModel
    ) async throws
}

final class SaveViewedFunFactUseCaseImpl: SaveViewedFunFactUseCase {
    private let repository: ViewedFunFactRepository

    init(repository: ViewedFunFactRepository) {
        self.repository = repository
    }

    func execute(
        filmId: Int,
        filmTitle: String,
        fact: FunFactModel
    ) async throws {
        try await repository.saveViewedFact(
            filmId: filmId,
            filmTitle: filmTitle,
            fact: fact
        )
    }
}
