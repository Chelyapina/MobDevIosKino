import Foundation // для работы с ошибками
import Combine // для observable

@MainActor final class FunFactViewModel: ObservableObject {
    
    @Published private(set) var state: State = .loading // private - для setter
    
    private let getFilmFacts: GetFilmFactsUseCase
    private let filmId: Int
    
    private let settings: UserDefaultsSettings
    
    enum State: Equatable {
        case loading
        case loaded(FunFactModel)
        case error(String)
    }
    
    init(getFilmFacts: GetFilmFactsUseCase, filmId: Int, settings: UserDefaultsSettings) {
        self.getFilmFacts = getFilmFacts
        self.filmId = filmId
        self.settings = settings
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
                .filter { fact in fact.type  == .fact && (!settings.hideSpoilers || !fact.isSpoiler)
                }
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
