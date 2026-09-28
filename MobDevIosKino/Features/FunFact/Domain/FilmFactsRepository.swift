protocol FilmFactsRepository {
    func getFacts(filmId: Int) async throws -> [FunFactModel]
}
