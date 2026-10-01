import SwiftUI
import SwiftData

@main
struct MobDevlosKinoApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: CachedFilm.self)
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
