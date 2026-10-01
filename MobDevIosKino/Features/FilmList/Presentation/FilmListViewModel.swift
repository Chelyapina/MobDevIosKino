import Foundation
import Combine

@MainActor
final class FilmListViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded([FilmListModel])
        case error(String)
    }

    @Published private(set) var state: State = .loading

    private let getFilmList: GetFilmListUseCase
    private let clearFilmList: ClearFilmListUseCase

    init(
        getFilmList: GetFilmListUseCase,
        clearFilmList: ClearFilmListUseCase
    ) {
        self.getFilmList = getFilmList
        self.clearFilmList = clearFilmList
    }

    func load() async {
        guard case .loading = state else { return }
        await fetch()
    }

    func retry() async {
        await fetch()
    }

    func forceReload() async {
        await fetch()
    }

    func clearAll() async {
        do {
            try await clearFilmList.execute()
            state = .loaded([])
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func fetch() async {
        state = .loading
        do {
            let films = try await getFilmList.execute()
            state = .loaded(films)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
