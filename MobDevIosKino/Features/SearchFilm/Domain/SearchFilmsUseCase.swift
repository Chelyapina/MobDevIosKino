import Foundation

protocol SearchFilmsUseCase {
    func execute(keyword: String, page: Int) async throws -> SearchPage
}

final class SearchFilmsUseCaseImpl: SearchFilmsUseCase {
    private let repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func execute(keyword: String, page: Int) async throws -> SearchPage {
        try await repository.search(keyword: keyword, page: page)
    }
}
