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
                    OneFilmView(
                        filmId: id,
                        onShowFunFact: {router.push(.funFact(id: id))
                        })

                case .funFact(let id):
                    FunFactView(viewModel: Self.makeFunFactViewModel(filmId: id))
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

    private static func makeFunFactViewModel(filmId: Int) -> FunFactViewModel {
        let service: NetworkService = NetworkServiceImpl(apiKey: "...")
        let repository: FilmFactsRepository = FilmFactsRepositoryImpl(service: service)
        let useCase: GetFilmFactsUseCase = GetFilmFactsUseCaseImpl(repository: repository)
        return FunFactViewModel(getFilmFacts: useCase, filmId: filmId)
    }
}

#Preview {
    RootView()
}
