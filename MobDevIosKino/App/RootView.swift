import SwiftUI

struct RootView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            FilmListView(
                viewModel: Self.makeFilmListViewModel(),
                onSelectFilm: { id in
                    router.push(.filmDetail(id: id))
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .filmDetail(let id):
                    OneFilmView(filmId: id)
                }
            }
        }
    }

    private static func makeFilmListViewModel() -> FilmListViewModel {
        let service: FilmListServiceProtocol = MockFilmListService()
        let repository: FilmListRepository = FilmListRepositoryImpl(service: service)
        let useCase: GetFilmListUseCase = GetFilmListUseCaseImpl(repository: repository)
        return FilmListViewModel(getFilmList: useCase)
    }
}

#Preview {
    RootView()
}
