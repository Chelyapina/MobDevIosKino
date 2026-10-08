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
                        viewModel: Self.makeOneFilmViewModel(filmId: id),
                        onShowFunFact: { title in
                            router.push(.funFact(id: id, title: title))
                        }, onShowViewedFacts:  {router.push(.viewedFacts)})
                    
                case .funFact(let id, let title):
                    FunFactView(viewModel: Self.makeFunFactViewModel(filmId: id, filmTitle: title, container: container))
                    
                case .viewedFacts:
                    ViewedFactsView(
                        viewModel: Self.makeViewedFactsViewModel(container: container)
                    )
                }
            }
        }
    }
    
    //STATIC FACTORY??
    
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
    
    private static func makeFunFactViewModel(filmId: Int, filmTitle: String, container: ModelContainer) -> FunFactViewModel {
        let storage = ViewedFunFactStorage(
            context: container.mainContext
        )
        let viewedRepository: ViewedFunFactRepository =
        ViewedFunFactRepositoryImpl(
            storage: storage
        )
        
        let saveViewedFact: SaveViewedFunFactUseCase =
        SaveViewedFunFactUseCaseImpl(
            repository: viewedRepository
        )
        
        let getViewedFacts: GetViewedFactsUseCase =
        GetViewedFactsUseCaseImpl(
            repository: viewedRepository
        )
        
        let service: NetworkService = NetworkServiceImpl(apiKey: "e46a05b2-b874-4127-8a3c-68cac31c2fb7")
        let repository: FilmFactsRepository = FilmFactsRepositoryImpl(service: service)
        let useCase: GetFilmFactsUseCase = GetFilmFactsUseCaseImpl(repository: repository)
        let settings: UserDefaultsSettings = UserDefaultsSettings()
        return FunFactViewModel(getFilmFacts: useCase, filmId: filmId, filmTitle: filmTitle, settings: settings, saveViewedFact: saveViewedFact, getViewedFacts: getViewedFacts)
    }
    
    private static func makeOneFilmViewModel(filmId: Int) -> OneFilmViewModel {
        let settings: UserDefaultsSettings = UserDefaultsSettings()
        let service: NetworkService = NetworkServiceImpl(apiKey: "e46a05b2-b874-4127-8a3c-68cac31c2fb7")
        let repository: OneFilmRepository = OneFilmRepositoryImpl(service: service)
        let getOneFilm: GetOneFilmUseCase = GetOneFilmUseCaseImpl(repository: repository)
        
        return OneFilmViewModel(settings: settings, filmId: filmId, getOneFilm: getOneFilm)
    }
    
    
    private static func makeViewedFactsViewModel(
        container: ModelContainer
    ) -> ViewedFactsViewModel {
        let storage = ViewedFunFactStorage(
            context: container.mainContext
        )
        
        let repository: ViewedFunFactRepository =
        ViewedFunFactRepositoryImpl(
            storage: storage
        )
        
        let getViewedFacts: GetViewedFactsUseCase =
        GetViewedFactsUseCaseImpl(
            repository: repository
        )
        
        let deleteViewedFact: DeleteViewedFactUseCase = DeleteViewedFactUseCaseImpl(repository: repository)
        
        return ViewedFactsViewModel(
            getViewedFacts: getViewedFacts,
            deleteViewedFact: deleteViewedFact
        )
    }
}


