import Foundation

@MainActor
final class OneFilmViewModel: ObservableObject {
    
    @Published private(set) var hideSpoilers: Bool
    private let settings: UserDefaultsSettings
    
    init(settings: UserDefaultsSettings) {
        self.settings = settings
        self.hideSpoilers = settings.hideSpoilers
    }
    
    func setHideSpoilers(_ value: Bool) {
        hideSpoilers = value
        settings.hideSpoilers = value
    }
}
