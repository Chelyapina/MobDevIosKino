import Foundation

final class FilmListRepositoryImpl: FilmListRepository {
    private let remote: FilmListServiceProtocol
    private let local: FilmLocalStore

    init(remote: FilmListServiceProtocol, local: FilmLocalStore) {
        self.remote = remote
        self.local = local
    }

    func fetchFilms(filters: FilmFilters) async throws -> FilmPage {
        do {
            let response = try await remote.getFilms(filters: filters)
            let films = response.toDomain()

            if filters.isDefault {
                try? await local.save(films)
            }

            return FilmPage(
                items: films,
                page: filters.page,
                totalPages: response.totalPages
            )
        } catch {
            if filters.isDefault,
               let cached = try? await local.fetchAll(),
               !cached.isEmpty {
                return FilmPage(items: cached, page: 1, totalPages: 1)
            }
            throw error
        }
    }

    func clearCache() async throws {
        try await local.deleteAll()
    }
}
