import Foundation

enum AppRoute: Hashable {   // какие маршруты вообще существуют в приложении?
    case filmDetail(id: Int)
    case funFact(id: Int)
    case viewedFacts
}
