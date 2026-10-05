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

    init(getViewedFacts: GetViewedFactsUseCase) {
        self.getViewedFacts = getViewedFacts
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
}
