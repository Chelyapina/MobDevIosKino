protocol GetViewedFactsUseCase {
    func execute() async throws -> [ViewedFunFactModel]
}

final class GetViewedFactsUseCaseImpl: GetViewedFactsUseCase {
    private let repository: ViewedFunFactRepository

    init(repository: ViewedFunFactRepository) {
        self.repository = repository
    }

    func execute() async throws -> [ViewedFunFactModel] {
        try await repository.getViewedFacts()
    }
}
