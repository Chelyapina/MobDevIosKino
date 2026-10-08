import SwiftUI
import SwiftData

@main
struct MobDevIosKinoApp: App {
    private let deps: AppDependencies

    init() {
        do {
            let container = try ModelContainer(
                for: CachedFilm.self,
                ViewedFunFact.self
            )
            self.deps = AppDependencies(container: container)
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(deps: deps)
        }
    }
}
