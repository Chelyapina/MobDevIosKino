import Foundation // для работы с ошибками
import Combine // для observable

@MainActor final class FunFactViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded(FunFactModel)
        case error(String)
    }

    @Published private(set) var state: State = .loading

    private let getFilmFacts: GetFilmFactsUseCase
    private let filmId: Int

    init(getFilmFacts: GetFilmFactsUseCase, filmId: Int) {
        self.getFilmFacts = getFilmFacts
        self.filmId = filmId
    }

    func load() async {
        guard case .loading = state else { return }
        await fetch()
    }

    func retry() async {
        await fetch()
    }

    private func fetch() async {
        state = .loading
        do {
            let facts = try await getFilmFacts.getFacts(filmId: filmId)

            let fact = facts
                .filter { $0.type == .fact && !$0.isSpoiler }
                .randomElement()

            guard let fact else {
                state = .error("Факты не найдены")
                return
            }

            state = .loaded(fact)

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
