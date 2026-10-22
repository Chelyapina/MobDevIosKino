import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(makeViewModel: @escaping () -> SearchViewModel) {
        _viewModel = State(wrappedValue: makeViewModel())
    }

    var body: some View {
        content
            .searchable(text: $viewModel.query, prompt: "Поиск фильмов")
            .navigationTitle("Поиск")
            .accessibilityIdentifier("search.screen")
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            promptState

        case .searching:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            emptyState

        case .error(let message):
            ErrorView(message: message, onRetry: viewModel.retry)

        case .loaded(let films, _):
            listContent(films)
        }
    }

    private func listContent(_ films: [SearchFilmModel]) -> some View {
        List {
            ForEach(films) { film in
                SearchFilmRowView(film: film)
                    .accessibilityIdentifier("searchFilm.card.\(film.id)")
                    .onAppear {
                        viewModel.loadNextPageIfNeeded(currentItem: film)
                    }
            }

            if viewModel.isLoadingNextPage {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
    }

    private var promptState: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Введите название фильма")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "film.stack")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Ничего не найдено")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundColor(.orange)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Повторить", action: onRetry)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
