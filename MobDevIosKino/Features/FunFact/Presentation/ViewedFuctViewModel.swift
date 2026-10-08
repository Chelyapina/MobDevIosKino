import Foundation

@MainActor
final class ViewedFactsViewModel: ObservableObject {

    enum State {
        case loading
        case loaded([ViewedFunFactModel])
        case error(String)
    }

    @Published private(set) var state: State = .loading

    private let getViewedFacts: GetViewedFactsUseCase
    private let deleteViewedFact: DeleteViewedFactUseCase

    init(getViewedFacts: GetViewedFactsUseCase, deleteViewedFact: DeleteViewedFactUseCase) {
        self.getViewedFacts = getViewedFacts
        self.deleteViewedFact = deleteViewedFact
    }

    func load() async {
        state = .loading

        do {
            let facts = try await getViewedFacts.execute()
            state = .loaded(facts)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func deleteFacts(
        at offsets: IndexSet,
        from facts: [ViewedFunFactModel]
    ) async {
        do {
            for index in offsets {
                let fact = facts[index]

                try await deleteViewedFact.execute(
                    filmId: fact.filmId,
                    text: fact.text
                )
            }

            await load()
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
