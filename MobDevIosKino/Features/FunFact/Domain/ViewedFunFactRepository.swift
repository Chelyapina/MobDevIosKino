protocol ViewedFunFactRepository {
    func saveViewedFact(
        filmId: Int,
        fact: FunFactModel
    ) async throws
    
    func getViewedFacts() async throws -> [ViewedFunFactModel]
}
