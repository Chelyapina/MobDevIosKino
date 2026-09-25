import SwiftUI

struct FilmListView: View {
    @StateObject private var viewModel: FilmListViewModel

    init(viewModel: @autoclosure @escaping () -> FilmListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Фильмы")
                .task {
                    await viewModel.load()
                }
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
                        FilmListOneElemView(film: film)
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

#Preview {
    FilmListView(
        viewModel: FilmListViewModel(
            getFilmList: GetFilmListUseCaseImpl(
                repository: FilmListRepositoryImpl(
                    service: MockFilmListService()
                )
            )
        )
    )
}
