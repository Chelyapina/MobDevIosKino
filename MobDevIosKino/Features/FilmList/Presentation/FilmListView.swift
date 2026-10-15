import SwiftUI

struct FilmListView: View {
    @StateObject private var viewModel: FilmListViewModel
    let onSelectFilm: (Int) -> Void
    let onOpenSearch: () -> Void

    @State private var selectedType: FilmType = .all
    @State private var ratingFrom: Double = 0

    init(
        viewModel: @autoclosure @escaping () -> FilmListViewModel,
        onSelectFilm: @escaping (Int) -> Void,
        onOpenSearch: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.onSelectFilm = onSelectFilm
        self.onOpenSearch = onOpenSearch
    }

    var body: some View {
        VStack(spacing: 0) {
            filtersBar
            Divider()
            content
        }
        .navigationTitle("Фильмы")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { onOpenSearch() } label: {
                    Image(systemName: "magnifyingglass")
                }

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
        .task { await viewModel.load() }
        .onChange(of: viewModel.state) { _, newState in
            guard case .loaded(let loaded) = newState else { return }
            if selectedType != loaded.filters.type {
                selectedType = loaded.filters.type
            }
            if ratingFrom != loaded.filters.ratingFrom {
                ratingFrom = loaded.filters.ratingFrom
            }
        }
    }


    private var filtersBar: some View {
        VStack(spacing: 8) {
            Picker("Тип", selection: $selectedType) {
                ForEach(FilmType.allCases) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedType) { _, newType in
                applyFilters(type: newType, rating: ratingFrom)
            }

            HStack(spacing: 12) {
                Text("Рейтинг от")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Slider(
                    value: $ratingFrom,
                    in: 0...10,
                    step: 0.5,
                    onEditingChanged: { editing in
                        if !editing {
                            applyFilters(type: selectedType, rating: ratingFrom)
                        }
                    }
                )

                Text(String(format: "%.1f", ratingFrom))
                    .font(.caption.monospacedDigit())
                    .frame(width: 32, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func applyFilters(type: FilmType, rating: Double) {
        var filters = FilmFilters()
        filters.type = type
        filters.ratingFrom = rating
        Task { await viewModel.applyFilters(filters) }
    }

    // MARK: - Helpers

    private var isLoading: Bool {
        if case .loading = viewModel.state { return true }
        return false
    }

    private var isClearDisabled: Bool {
        if case .loaded(let loaded) = viewModel.state, loaded.films.isEmpty {
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

        case .loaded(let loaded):
            if loaded.films.isEmpty {
                emptyState
            } else {
                VStack(spacing: 0) {
                    listContent(loaded)
                    Divider()
                    paginationBar(loaded)
                }
            }

        case .error(let message):
            errorContent(message)
        }
    }

    private func listContent(_ loaded: FilmListViewModel.LoadedState) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(loaded.films) { film in
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


    private func paginationBar(_ loaded: FilmListViewModel.LoadedState) -> some View {
        HStack {
            Button {
                Task { await viewModel.goToPrevPage() }
            } label: {
                Label("Назад", systemImage: "chevron.left")
            }
            .disabled(!loaded.hasPrev || viewModel.isPageLoading)

            Spacer()

            if viewModel.isPageLoading {
                ProgressView()
                    .controlSize(.small)
            } else {
                Text("\(loaded.currentPage) / \(loaded.totalPages)")
                    .font(.footnote.monospacedDigit())
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button {
                Task { await viewModel.goToNextPage() }
            } label: {
                Label("Вперёд", systemImage: "chevron.right")
                    .labelStyle(.titleAndIcon)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .disabled(!loaded.hasNext || viewModel.isPageLoading)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.stack")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Ничего не найдено")
                .foregroundColor(.secondary)
            Button("Сбросить фильтры") {
                selectedType = .all
                ratingFrom = 0
                applyFilters(type: .all, rating: 0)
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
