import Foundation

enum AppRoute: Hashable {   // какие маршруты вообще существуют в приложении?
    case filmDetail(id: Int)
    case funFact(id: Int, title: String) // title для передачи привязки к фильму
    case viewedFacts
}
