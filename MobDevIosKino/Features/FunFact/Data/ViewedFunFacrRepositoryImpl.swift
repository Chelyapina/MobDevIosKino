final class ViewedFunFactRepositoryImpl: ViewedFunFactRepository {
    private let storage: ViewedFunFactStorage

    init(storage: ViewedFunFactStorage) {
        self.storage = storage
    }

    func saveViewedFact(
        filmId: Int,
        fact: FunFactModel
    ) async throws {
        if let viewedFact = try await storage.get(
            filmId: filmId,
            text: fact.text
        ) {
            try await storage.update(viewedFact)
        } else {
            try await storage.save(
                filmId: filmId,
                fact: fact
            )
        }
    }
    
    func getViewedFacts() async throws -> [ViewedFunFactModel] { // для загрузки уже просмотренных
        let viewedFacts = try await storage.getAll()

        return viewedFacts.enumerated().map { index, fact in
            ViewedFunFactModel(
                id: index + 1,
                filmId: fact.filmId,
                text: fact.text,
                type: FunFactType(rawValue: fact.type) ?? .fact,
                isSpoiler: fact.isSpoiler,
                viewedAt: fact.viewedAt
            )
        }
    }
}
