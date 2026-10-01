import SwiftUI
import SwiftData

struct RootView: View {
    @StateObject private var router = AppRouter()
    let container: ModelContainer

    var body: some View {
        NavigationStack(path: $router.path) {
            FilmListView(
                viewModel: Self.makeFilmListViewModel(container: container),
                onSelectFilm: { id in
                    router.push(.filmDetail(id: id))
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .filmDetail(let id):
                    OneFilmView(
                        filmId: id,
                        onShowFunFact: {
                            router.push(.funFact(id: id))
                        }
                    )

                case .funFact(let id):
                    FunFactView(viewModel: Self.makeFunFactViewModel(filmId: id))
                }
            }
        }
    }

    private static func makeFilmListViewModel(container: ModelContainer) -> FilmListViewModel {
        let remote: FilmListServiceProtocol = MockFilmListService()
        let local: FilmLocalStore = SwiftDataFilmStore(context: container.mainContext)
        let repository: FilmListRepository = FilmListRepositoryImpl(
            remote: remote,
            local: local
        )
        let getUseCase: GetFilmListUseCase = GetFilmListUseCaseImpl(repository: repository)
        let clearUseCase: ClearFilmListUseCase = ClearFilmListUseCaseImpl(repository: repository)
        return FilmListViewModel(
            getFilmList: getUseCase,
            clearFilmList: clearUseCase
        )
    }

    private static func makeFunFactViewModel(filmId: Int) -> FunFactViewModel {
        let service: NetworkService = NetworkServiceImpl(apiKey: "...")
        let repository: FilmFactsRepository = FilmFactsRepositoryImpl(service: service)
        let useCase: GetFilmFactsUseCase = GetFilmFactsUseCaseImpl(repository: repository)
        return FunFactViewModel(getFilmFacts: useCase, filmId: filmId)
    }
}

#Preview {
    RootView(container: try! ModelContainer(for: CachedFilm.self))
}
