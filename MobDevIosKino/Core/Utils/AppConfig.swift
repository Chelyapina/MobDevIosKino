import Foundation

enum AppConfig {
    static let baseURL = "https://kinopoiskapiunofficial.tech"

    static var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(
                from: data, format: nil
            ) as? [String: Any],
            let key = dict["API_KEY"] as? String,
            !key.isEmpty
        else {
            fatalError("Отсутствует файл Secrets.plist с API_KEY")
        }
        return key
    }
}
