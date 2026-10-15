import Foundation

final class FilmListService: FilmListServiceProtocol {
    private let network: NetworkService

    init(network: NetworkService) {
        self.network = network
    }

    func getFilms(filters: FilmFilters) async throws -> FilmListResponseDTO {
        let endpoint = Endpoint.films(
            type: filters.type == .all ? nil : filters.type.rawValue,
            ratingFrom: filters.ratingFrom > 0 ? filters.ratingFrom : nil,
            page: filters.page
        )
        return try await network.request(endpoint: endpoint)
    }
}
