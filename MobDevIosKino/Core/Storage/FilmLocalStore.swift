import Foundation

protocol FilmLocalStore {
    func fetchAll() async throws -> [FilmListModel]
    func save(_ films: [FilmListModel]) async throws
    func deleteAll() async throws
}
