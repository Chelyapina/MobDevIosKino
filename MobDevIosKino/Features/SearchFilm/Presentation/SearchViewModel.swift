import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    enum State {
        case idle
        case searching
        case loaded(films: [SearchFilmModel], hasMore: Bool)
        case empty
        case error(message: String)
    }
    
    private(set) var state: State = .idle
    private(set) var isLoadingNextPage = false

    var query: String = "" {
        didSet { scheduleSearch() }
    }

    private let searchFilms: SearchFilmsUseCase

    private var currentPage = 1
    private var currentKeyword = ""
    private var lastCompletedKeyword = ""
    private var searchTask: Task<Void, Never>?

    private let debounce: Duration = .milliseconds(300)
    private let minQueryLength = 2

    init(searchFilms: SearchFilmsUseCase) {
        self.searchFilms = searchFilms
    }

    func retry() {
        scheduleSearch(immediate: true)
    }

    func loadNextPageIfNeeded(currentItem: SearchFilmModel) {
        guard case .loaded(let films, let hasMore) = state, hasMore else { return }
        guard !isLoadingNextPage, !films.isEmpty else { return }
        guard films.suffix(3).contains(where: { $0.id == currentItem.id }) else { return }

        Task { [weak self] in
            await self?.loadNextPage()
        }
    }

    private func scheduleSearch(immediate: Bool = false) {
        searchTask?.cancel()

        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard keyword.count >= minQueryLength else {
            state = .idle
            isLoadingNextPage = false
            currentKeyword = ""
            lastCompletedKeyword = ""
            return
        }

        currentKeyword = keyword

        searchTask = Task { [weak self] in
            guard let self else { return }
            if !immediate {
                do {
                    try await Task.sleep(for: self.debounce)
                } catch {
                    return
                }
            }
            guard !Task.isCancelled else { return }
            
            await self.performSearch(keyword: keyword)
        }
    }

    private func performSearch(keyword: String) async {
        if keyword == lastCompletedKeyword, case .loaded = state {
            return
        }

        state = .searching
        currentPage = 1

        do {
            let page = try await searchFilms.execute(keyword: keyword, page: 1)
            
            guard currentKeyword == keyword, !Task.isCancelled else { return }

            if page.films.isEmpty {
                state = .empty
            } else {
                var seenIDs = Set<SearchFilmModel.ID>()
                let uniqueFilms = page.films.filter { seenIDs.insert($0.id).inserted }
                
                state = .loaded(films: uniqueFilms, hasMore: page.hasMore)
            }
            lastCompletedKeyword = keyword
        } catch {
            guard currentKeyword == keyword, !Task.isCancelled else { return }
            
            if let networkError = error as? NetworkError {
                state = .error(message: networkError.userMessage)
            } else {
                state = .error(message: NetworkError.unknown.userMessage)
            }
        }
    }

    private func loadNextPage() async {
        guard case .loaded(_, let hasMore) = state, hasMore else { return }
        guard !isLoadingNextPage else { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        let nextPage = currentPage + 1
        let keyword = currentKeyword

        do {
            let page = try await searchFilms.execute(keyword: keyword, page: nextPage)
            
            guard currentKeyword == keyword, !Task.isCancelled else { return }
            guard case .loaded(let currentFilms, _) = state else { return }

            let currentIDs = Set(currentFilms.map { $0.id })
            let uniqueNewFilms = page.films.filter { !currentIDs.contains($0.id) }

            state = .loaded(
                films: currentFilms + uniqueNewFilms,
                hasMore: page.hasMore
            )
            currentPage = nextPage
        } catch {
            return
        }
    }
}
