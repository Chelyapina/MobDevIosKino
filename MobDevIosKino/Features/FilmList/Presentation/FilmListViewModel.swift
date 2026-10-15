import Foundation
import Combine

@MainActor
final class FilmListViewModel: ObservableObject {

    struct LoadedState: Equatable {
        var films: [FilmListModel]
        var filters: FilmFilters
        var currentPage: Int
        var totalPages: Int

        var hasPrev: Bool { currentPage > 1 }
        var hasNext: Bool { currentPage < totalPages }
    }

    enum State: Equatable {
        case loading
        case loaded(LoadedState)
        case error(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var isPageLoading = false

    private let getFilmList: GetFilmListUseCase
    private let clearFilmList: ClearFilmListUseCase
    private var currentFilters: FilmFilters = .default

    init(
        getFilmList: GetFilmListUseCase,
        clearFilmList: ClearFilmListUseCase
    ) {
        self.getFilmList = getFilmList
        self.clearFilmList = clearFilmList
    }

    func load() async {
        guard case .loading = state else { return }
        await fetchPage(filters: currentFilters, page: 1, showFullLoading: true)
    }

    func retry() async {
        await fetchPage(filters: currentFilters, page: currentPage, showFullLoading: true)
    }

    func forceReload() async {
        await fetchPage(filters: currentFilters, page: 1, showFullLoading: true)
    }

    func applyFilters(_ filters: FilmFilters) async {
        currentFilters = filters
        await fetchPage(filters: filters, page: 1, showFullLoading: true)
    }

    func goToNextPage() async {
        guard case .loaded(let loaded) = state, loaded.hasNext else { return }
        await fetchPage(filters: loaded.filters, page: loaded.currentPage + 1, showFullLoading: false)
    }

    func goToPrevPage() async {
        guard case .loaded(let loaded) = state, loaded.hasPrev else { return }
        await fetchPage(filters: loaded.filters, page: loaded.currentPage - 1, showFullLoading: false)
    }

    func clearAll() async {
        do {
            try await clearFilmList.execute()
            currentFilters = .default
            state = .loaded(
                LoadedState(
                    films: [],
                    filters: .default,
                    currentPage: 1,
                    totalPages: 1
                )
            )
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private var currentPage: Int {
        if case .loaded(let loaded) = state { return loaded.currentPage }
        return 1
    }

    private func fetchPage(
        filters: FilmFilters,
        page: Int,
        showFullLoading: Bool
    ) async {
        var request = filters
        request.page = page

        if showFullLoading {
            state = .loading
        } else {
            isPageLoading = true
        }

        do {
            let result = try await getFilmList.execute(filters: request)

            state = .loaded(
                LoadedState(
                    films: result.items,
                    filters: filters,
                    currentPage: result.page,
                    totalPages: result.totalPages
                )
            )
            isPageLoading = false
        } catch {
            isPageLoading = false
            if showFullLoading {
                state = .error(error.localizedDescription)
            }
        }
    }
}
