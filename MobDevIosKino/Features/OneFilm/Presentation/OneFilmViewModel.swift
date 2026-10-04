import Foundation

@MainActor
final class OneFilmViewModel: ObservableObject {
    
    @Published private(set) var hideSpoilers: Bool
    private let settings: UserDefaultsSettings
    @Published private(set) var state: State = .loading // private - для setter
    
    private let getOneFilm: GetOneFilmUseCase
    private let filmId: Int
    
    enum State: Equatable {
        case loading
        case loaded(OneFilmModel)
        case error(String)
    }
    
    init(settings: UserDefaultsSettings, filmId: Int, getOneFilm: GetOneFilmUseCase) {
        self.settings = settings
        self.hideSpoilers = settings.hideSpoilers
        self.filmId = filmId
        self.getOneFilm = getOneFilm
    }
    
    func setHideSpoilers(_ value: Bool) {
        hideSpoilers = value
        settings.hideSpoilers = value
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
            let filmInfo = try await getOneFilm.getFilm(filmId: filmId)
            
            state = .loaded(filmInfo)
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
