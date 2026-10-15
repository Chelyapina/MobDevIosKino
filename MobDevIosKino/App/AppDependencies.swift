import SwiftData

@MainActor
final class AppDependencies {
    let container: ModelContainer

    private let networkService: NetworkService
    private let settings: UserDefaultsSettings

    init(container: ModelContainer) {
        self.container = container
        self.networkService = NetworkServiceImpl(apiKey: AppConfig.apiKey)
        self.settings = UserDefaultsSettings()
    }
}

extension AppDependencies {
    func makeFilmListViewModel() -> FilmListViewModel {
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

    func makeOneFilmViewModel(filmId: Int) -> OneFilmViewModel {
        let repository: OneFilmRepository = OneFilmRepositoryImpl(service: networkService)
        let getOneFilm: GetOneFilmUseCase = GetOneFilmUseCaseImpl(repository: repository)
        return OneFilmViewModel(
            settings: settings,
            filmId: filmId,
            getOneFilm: getOneFilm
        )
    }
}

extension AppDependencies {
    func makeSearchViewModel() -> SearchViewModel {
        let repository: SearchRepository = SearchRepositoryImpl(service: networkService)
        let useCase: SearchFilmsUseCase = SearchFilmsUseCaseImpl(repository: repository)
        return SearchViewModel(searchFilms: useCase)
    }
}

extension AppDependencies {
    func makeFunFactViewModel(filmId: Int, filmTitle: String) -> FunFactViewModel {
        let viewedRepository = makeViewedFunFactRepository()

        let saveViewedFact: SaveViewedFunFactUseCase = SaveViewedFunFactUseCaseImpl(repository: viewedRepository)
        let getViewedFacts: GetViewedFactsUseCase = GetViewedFactsUseCaseImpl(repository: viewedRepository)

        let filmFactsRepository: FilmFactsRepository = FilmFactsRepositoryImpl(service: networkService)
        let getFilmFacts: GetFilmFactsUseCase = GetFilmFactsUseCaseImpl(repository: filmFactsRepository)

        return FunFactViewModel(
            getFilmFacts: getFilmFacts,
            filmId: filmId,
            filmTitle: filmTitle,
            settings: settings,
            saveViewedFact: saveViewedFact,
            getViewedFacts: getViewedFacts
        )
    }

    func makeViewedFactsViewModel() -> ViewedFactsViewModel {
        let repository = makeViewedFunFactRepository()

        let getViewedFacts: GetViewedFactsUseCase = GetViewedFactsUseCaseImpl(repository: repository)
        let deleteViewedFact: DeleteViewedFactUseCase = DeleteViewedFactUseCaseImpl(repository: repository)

        return ViewedFactsViewModel(
            getViewedFacts: getViewedFacts,
            deleteViewedFact: deleteViewedFact
        )
    }

    private func makeViewedFunFactRepository() -> ViewedFunFactRepository {
        let storage = ViewedFunFactStorage(context: container.mainContext)
        return ViewedFunFactRepositoryImpl(storage: storage)
    }
}
