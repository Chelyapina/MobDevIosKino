import Foundation // для работы с ошибками
import Combine // для observable

@MainActor final class FunFactViewModel: ObservableObject {
    
    @Published private(set) var state: State = .loading // private - для setter
    
    // local storage
    private let saveViewedFact: SaveViewedFunFactUseCase
    private let getViewedFacts: GetViewedFactsUseCase
    
    
    private let getFilmFacts: GetFilmFactsUseCase
    private let filmId: Int
    
    private let settings: UserDefaultsSettings
    
    private let filmTitle: String
    
    enum State: Equatable {
        case loading
        case loaded(FunFactModel)
        case error(String)
    }
    
    init(getFilmFacts: GetFilmFactsUseCase, filmId: Int, filmTitle: String, settings: UserDefaultsSettings,     saveViewedFact: SaveViewedFunFactUseCase, getViewedFacts: GetViewedFactsUseCase) {
        self.getFilmFacts = getFilmFacts
        self.filmId = filmId
        self.filmTitle = filmTitle
        self.settings = settings
        self.saveViewedFact = saveViewedFact
        self.getViewedFacts = getViewedFacts
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
                .filter { fact in
                    fact.type == .fact &&
                    (!settings.hideSpoilers || !fact.isSpoiler)
                }
                .randomElement()
            
            guard let fact else {
                state = .error("Факты не найдены")
                return
            }
            
            state = .loaded(fact)
            
            do {
                try await saveViewedFact.execute(
                    filmId: filmId,
                    filmTitle: filmTitle,
                    fact: fact
                )
            } catch {
                print("Не удалось сохранить просмотренный факт: \(error)")
            }
        } catch let error as NetworkError {
            // При сетевой ошибке пробуем загрузить сохранённый факт.
            // Если его нет, показываем исходную сетевую ошибку.
            await loadViewedFact(fallbackMessage: error.userMessage)
            
        } catch {
            await loadViewedFact(fallbackMessage: "Что-то пошло не так")
        }
    }
    
    private func loadViewedFact(fallbackMessage: String) async {
        do {
            let facts = try await getViewedFacts.execute()

            let fact = facts
                .filter { fact in
                    fact.filmId == filmId &&
                    fact.type == .fact &&
                    (!settings.hideSpoilers || !fact.isSpoiler)
                }
                .randomElement()

            guard let fact else {
                // Нет локальных фактов — показываем исходную ошибку
                state = .error(fallbackMessage)
                return
            }

            // Если есть сохранённый факт — показываем его
            state = .loaded(
                FunFactModel(
                    text: fact.text,
                    type: fact.type,
                    isSpoiler: fact.isSpoiler
                )
            )

        } catch {
            // Не удалось получить данные из локального хранилища
            state = .error(fallbackMessage)
        }
    }
}
