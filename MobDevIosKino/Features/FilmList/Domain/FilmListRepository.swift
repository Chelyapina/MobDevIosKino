import Foundation

protocol FilmListRepository {
    func fetchFilms(filters: FilmFilters) async throws -> FilmPage
    func clearCache() async throws
}
