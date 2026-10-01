import Foundation

final class UserDefaultsSettings {
    private enum Keys {
        static let hideSpoilers = "hideSpoilers"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hideSpoilers: Bool {
        get {
            defaults.bool(forKey: Keys.hideSpoilers)
        }
        set {
            defaults.set(newValue, forKey: Keys.hideSpoilers)
        }
    }
}
