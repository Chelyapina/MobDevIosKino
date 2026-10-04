protocol OneFilmRepository {
    func getAllInfo(filmId: Int) async throws -> OneFilmModel
}

