import Foundation

struct SearchFilmModel : Identifiable{
    let id: Int
    let title: String
    let year: String?
    let description: String?
    let posterURL: URL?
}

struct SearchPage {
    let films: [SearchFilmModel]
    let page: Int
    let totalPages: Int
    let totalCount: Int

    var hasMore: Bool { page < totalPages }
}
