import Foundation
import SwiftData

@MainActor
final class SwiftDataFilmStore: FilmLocalStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() async throws -> [FilmListModel] {
        let descriptor = FetchDescriptor<CachedFilm>(
            sortBy: [SortDescriptor(\.id)]
        )
        let cached = try context.fetch(descriptor)
        return cached.map { $0.toDomain() }
    }

    func save(_ films: [FilmListModel]) async throws {
        try context.delete(model: CachedFilm.self)

        for film in films {
            context.insert(CachedFilm(from: film))
        }
        try context.save()
    }

    func deleteAll() async throws {
        try context.delete(model: CachedFilm.self)
        try context.save()
    }
}
