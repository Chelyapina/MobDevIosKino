import Foundation

enum FilmType: String, CaseIterable, Identifiable {
    case all        = "ALL"
    case film       = "FILM"
    case tvShow     = "TV_SHOW"
    case tvSeries   = "TV_SERIES"
    case miniSeries = "MINI_SERIES"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:        return "Все"
        case .film:       return "Фильмы"
        case .tvShow:     return "ТВ-шоу"
        case .tvSeries:   return "Сериалы"
        case .miniSeries: return "Мини"
        }
    }
}

struct FilmFilters: Equatable {
    var type: FilmType = .all
    var ratingFrom: Double = 0
    var page: Int = 1

    static let `default` = FilmFilters()

    var isDefault: Bool {
        type == .all && ratingFrom == 0 && page == 1
    }
}
