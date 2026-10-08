import SwiftUI

struct RootView: View {
    @StateObject private var router = AppRouter()
    let deps: AppDependencies

    var body: some View {
        NavigationStack(path: $router.path) {
            FilmListView(
                viewModel: deps.makeFilmListViewModel(),
                onSelectFilm: { id in
                    router.push(.filmDetail(id: id))
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .filmDetail(let id):
                    OneFilmView(
                        viewModel: deps.makeOneFilmViewModel(filmId: id),
                        onShowFunFact: { title in
                            router.push(.funFact(id: id, title: title))
                        },
                        onShowViewedFacts: {
                            router.push(.viewedFacts)
                        }
                    )

                case .funFact(let id, let title):
                    FunFactView(
                        viewModel: deps.makeFunFactViewModel(filmId: id, filmTitle: title)
                    )

                case .viewedFacts:
                    ViewedFactsView(
                        viewModel: deps.makeViewedFactsViewModel()
                    )
                }
            }
        }
    }
}
