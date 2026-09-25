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

    init(getFilmList: GetFilmListUseCase) {
        self.getFilmList = getFilmList
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
            let films = try await getFilmList.execute()
            state = .loaded(films)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
