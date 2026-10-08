protocol ViewedFunFactRepository {
    func saveViewedFact(
        filmId: Int,
        filmTitle: String,
        fact: FunFactModel
    ) async throws
    
    func getViewedFacts() async throws -> [ViewedFunFactModel]
    
    func deleteViewedFact(filmId: Int, text: String) async throws
    
}
