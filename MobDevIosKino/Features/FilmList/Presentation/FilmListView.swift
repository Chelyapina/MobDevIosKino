import SwiftUI

struct FilmListView: View {
    @StateObject private var viewModel: FilmListViewModel
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
            .task {
                await viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Загрузка...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let films):
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

        case .error(let message):
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
}
