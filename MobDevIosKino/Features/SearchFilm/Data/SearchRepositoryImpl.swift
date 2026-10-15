import Foundation

final class SearchRepositoryImpl: SearchRepository {
    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func search(keyword: String, page: Int) async throws -> SearchPage {
        let response: SearchFilmsResponseDTO = try await service.request(
            endpoint: .searchFilms(keyword: keyword, page: page)
        )
        let films = response.films.map { dto in
            SearchFilmModel(
                id: dto.filmId,
                title: dto.nameRu ?? dto.nameEn ?? "—",
                year: dto.year,
                description: dto.description,
                posterURL: dto.posterUrlPreview.flatMap(URL.init(string:))
            )
        }
        return SearchPage(
            films: films,
            page: page,
            totalPages: response.pagesCount,
            totalCount: response.searchFilmsCountResult
        )
    }
}
