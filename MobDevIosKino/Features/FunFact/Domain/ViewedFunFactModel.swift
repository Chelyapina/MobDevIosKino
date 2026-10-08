import Foundation

struct ViewedFunFactModel: Identifiable, Equatable {
    let id: Int
    let filmId: Int
    let text: String
    var filmTitle: String
    let type: FunFactType
    let isSpoiler: Bool
    let viewedAt: Date
}
