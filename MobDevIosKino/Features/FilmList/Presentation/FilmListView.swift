import SwiftUI

struct FilmListView: View {
    @StateObject private var viewModel: FilmListViewModel // сохранить объект независимо от пересоздания структуры view
    let onSelectFilm: (Int) -> Void

    init(
        viewModel: @autoclosure @escaping () -> FilmListViewModel,
        onSelectFilm: @escaping (Int) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.onSelectFilm = onSelectFilm
    }
    

    var body: some View {
        content
            .navigationTitle("Фильмы")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.forceReload() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isLoading)

                    Button(role: .destructive) {
                        Task { await viewModel.clearAll() }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .disabled(isClearDisabled)
                }
            }
            .task {
                await viewModel.load()
            }
    }

    private var isLoading: Bool {
        if case .loading = viewModel.state { return true }
        return false
    }

    private var isClearDisabled: Bool {
        if case .loaded(let films) = viewModel.state, films.isEmpty {
            return true
        }
        return false
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Загрузка...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let films):
            if films.isEmpty {
                emptyState
            } else {
                listContent(films)
            }

        case .error(let message):
            errorContent(message)
        }
    }

    private func listContent(_ films: [FilmListModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(films) { film in
                    Button {
                        onSelectFilm(film.id)
                    } label: {
                        FilmListOneElemView(film: film)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.stack")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Список пуст")
                .foregroundColor(.secondary)
            Button("Загрузить") {
                Task { await viewModel.forceReload() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorContent(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button("Повторить") {
                Task { await viewModel.retry() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
