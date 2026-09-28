import Foundation // системные типы данных

struct FilmListModel: Identifiable, Equatable {
    let id: Int
    let title: String
    let originalTitle: String?
    let year: Int?
    let rating: Double?
    let genres: [String]
    let posterURL: URL?
}
