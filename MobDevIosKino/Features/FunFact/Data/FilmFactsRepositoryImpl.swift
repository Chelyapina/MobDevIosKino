import Foundation
internal import UIKit

final class FilmFactsRepositoryImpl: FilmFactsRepository {
    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func getFacts(filmId id: Int) async throws -> [FunFactModel] { //filmId - имя при вызове, id - имя внутри функции
        let response: FilmFactsResponseDTO = try await service.request(
            endpoint: .filmFacts(id: id)
        )
        return response.items.map { item in
            FunFactModel(
                text: removeHTML(from: item.text),
                type: item.type == "FACT" ? FunFactType.fact : FunFactType.blooper,
                isSpoiler: item.spoiler
            )
        }
    }

    private func removeHTML(from text: String) -> String {
        guard let data = text.data(using: .utf8) else {
            return text
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return text
        }

        return attributedString.string
    }
}
