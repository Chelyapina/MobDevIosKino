final class ViewedFunFactRepositoryImpl: ViewedFunFactRepository {
    private let storage: ViewedFunFactStorage

    init(storage: ViewedFunFactStorage) {
        self.storage = storage
    }

    func saveViewedFact(
        filmId: Int,
        filmTitle: String,
        fact: FunFactModel
    ) async throws {
        if let viewedFact = try await storage.get(
            filmId: filmId,
            text: fact.text
        ) {
            try await storage.update(viewedFact)    // обновляем дату просмотра, если уже видели факт
        } else {
            try await storage.save(     // если факт еще не просматривали
                filmId: filmId,
                filmTitle: filmTitle,
                fact: fact
            )
        }
    }
    
    func getViewedFacts() async throws -> [ViewedFunFactModel] { // загрузка уже просмотренных фактов
        let viewedFacts = try await storage.getAll()

        return viewedFacts.enumerated().map { index, fact in
            ViewedFunFactModel(
                id: index + 1,
                filmId: fact.filmId,
                text: fact.text,
                filmTitle: fact.filmTitle,
                type: FunFactType(rawValue: fact.type) ?? .fact,
                isSpoiler: fact.isSpoiler,
                viewedAt: fact.viewedAt
            )
        }
    }
    
    func deleteViewedFact(  // удаление по запросу
        filmId: Int,
        text: String
    ) async throws {
        guard let viewedFact = try await storage.get(
            filmId: filmId,
            text: text
        ) else {
            return
        }

        try await storage.delete(viewedFact)
    }
}
