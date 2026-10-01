import SwiftData
import Foundation

@Model
final class CachedFilm {
    @Attribute(.unique) var id: Int
    var title: String
    var originalTitle: String?
    var year: Int?
    var rating: Double?
    var genres: [String]
    var posterURL: URL?

    init(
        id: Int,
        title: String,
        originalTitle: String?,
        year: Int?,
        rating: Double?,
        genres: [String],
        posterURL: URL?
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.year = year
        self.rating = rating
        self.genres = genres
        self.posterURL = posterURL
    }
}
