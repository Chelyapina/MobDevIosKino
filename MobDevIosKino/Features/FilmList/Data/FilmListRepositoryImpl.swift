import Foundation

final class FilmListRepositoryImpl: FilmListRepository {
    private let service: FilmListServiceProtocol

    init(service: FilmListServiceProtocol) {
        self.service = service
    }

    func fetchFilms() async throws -> [FilmListModel] {
        let response = try await service.getFilms()
        return response.toDomain()
    }
}
