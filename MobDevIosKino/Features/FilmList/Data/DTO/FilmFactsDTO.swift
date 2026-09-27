import Foundation

struct FilmFactsResponseDTO: Decodable {
    let total: Int
    let items: [OneFactDTO]
}

struct OneFactDTO: Decodable {
    let text: String
    let type: String
    let spoiler: Bool
}
