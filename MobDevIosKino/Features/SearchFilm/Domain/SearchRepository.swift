import Foundation

protocol SearchRepository {
    func search(keyword: String, page: Int) async throws -> SearchPage
}
