import Foundation
import SwiftData

@MainActor
final class ViewedFunFactStorage {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: Create
    func save(
        filmId: Int,
        filmTitle: String,
        fact: FunFactModel
    ) throws {
        let viewedFact = ViewedFunFact(
            filmId: filmId,
            text: fact.text,
            filmTitle: filmTitle,
            type: fact.type.rawValue,
            isSpoiler: fact.isSpoiler
        )

        context.insert(viewedFact)
        try context.save()
    }

    // MARK: Read
    func getAll() throws -> [ViewedFunFact] {
        let descriptor = FetchDescriptor<ViewedFunFact>(
            sortBy: [
                SortDescriptor(\.viewedAt, order: .reverse)
            ]
        )

        return try context.fetch(descriptor)
    }

    func get(
            filmId: Int,
            text: String
        ) throws -> ViewedFunFact? {
            let id = filmId
            let factText = text

            let descriptor = FetchDescriptor<ViewedFunFact>(
                predicate: #Predicate { fact in
                    fact.filmId == id &&
                    fact.text == factText
                }
            )

            return try context.fetch(descriptor).first
        }   

    // MARK: Update
    func update(    // обновляем дату просмотра факта
        _ viewedFact: ViewedFunFact
    ) throws {
        viewedFact.viewedAt = Date()

        try context.save()
    }

    // MARK: Delete
    func delete(_ viewedFact: ViewedFunFact) throws {
        context.delete(viewedFact)
        try context.save()
    }

    func deleteAll() throws {
        let facts = try getAll()

        for fact in facts {
            context.delete(fact)
        }

        try context.save()
    }
}
