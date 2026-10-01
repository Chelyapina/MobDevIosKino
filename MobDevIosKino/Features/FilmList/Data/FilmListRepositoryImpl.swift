import Foundation

final class FilmListRepositoryImpl: FilmListRepository {
    private let remote: FilmListServiceProtocol
    private let local: FilmLocalStore

    init(remote: FilmListServiceProtocol, local: FilmLocalStore) {
        self.remote = remote
        self.local = local
    }

    func fetchFilms() async throws -> [FilmListModel] {
        if let cached = try? await local.fetchAll(), !cached.isEmpty {
            return cached
        }

        let dtos = try await remote.getFilms()
        let films = dtos.toDomain()

        try? await local.save(films)

        return films
    }

    func clearCache() async throws {
        try await local.deleteAll()
    }
}
