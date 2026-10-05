import Foundation
import SwiftData

@Model
final class ViewedFunFact {

    var filmId: Int
    var text: String
    var type: String
    var isSpoiler: Bool
    var viewedAt: Date

    init(
        filmId: Int,
        text: String,
        type: String,
        isSpoiler: Bool,
        viewedAt: Date = Date()
    ) {
        self.filmId = filmId
        self.text = text
        self.type = type
        self.isSpoiler = isSpoiler
        self.viewedAt = viewedAt
    }
}



