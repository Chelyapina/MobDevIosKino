import SwiftUI

@main
struct MobDevlosKinoApp: App {
    var body: some Scene {
        WindowGroup {
            FilmListView(viewModel: Self.makeViewModel())
        }
    }

    private static func makeViewModel() -> FilmListViewModel {
        let service: FilmListServiceProtocol = MockFilmListService()
        let repository: FilmListRepository = FilmListRepositoryImpl(service: service)
        let useCase: GetFilmListUseCase = GetFilmListUseCaseImpl(repository: repository)
        return FilmListViewModel(getFilmList: useCase)
    }
}
