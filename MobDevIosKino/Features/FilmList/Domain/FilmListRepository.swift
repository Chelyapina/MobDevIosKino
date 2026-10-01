import Foundation

protocol FilmListRepository {
    func fetchFilms() async throws -> [FilmListModel]
    func clearCache() async throws
}
