import SwiftUI

struct OneFilmView: View {
    @StateObject private var viewModel: OneFilmViewModel

    let onShowFunFact: (String) -> Void
    let onShowViewedFacts: () -> Void

    init(
        viewModel: @autoclosure @escaping() -> OneFilmViewModel,
        onShowFunFact: @escaping (String) -> Void,
        onShowViewedFacts: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.onShowFunFact = onShowFunFact
        self.onShowViewedFacts = onShowViewedFacts
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            Circle()
                .fill(Color.purple.opacity(0.12))
                .frame(width: 350, height: 350)
                .blur(radius: 80)
                .offset(x: 150, y: -250)

            content
        }
        .task {
            await viewModel.load()
        }
        .toolbar {
               ToolbarItem(placement: .topBarTrailing) {
                   Button {
                       onShowViewedFacts()
                   } label: {
                       Image(systemName: "clock.arrow.circlepath")
                   }
               }
           }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()

        case .loaded(let film):
            filmContent(film)

        case .error(let message):
            VStack(spacing: 16) {
                Text("Не удалось загрузить фильм")
                    .font(.headline)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Повторить") {
                    Task {
                        await viewModel.retry()
                    }
                }
            }
            .padding()
        }
    }

    private func filmContent(_ film: OneFilmModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                poster(film)

                VStack(alignment: .leading, spacing: 8) {
                    Text(film.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    if let originalTitle = film.originalTitle {
                        Text(originalTitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                filmInfo(film)

                if let description = film.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("О фильме")
                            .font(.headline)

                        Text(description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }
                }

                Divider()

                Toggle(
                    "Скрывать спойлеры",
                    isOn: Binding(
                        get: {
                            viewModel.hideSpoilers
                        },
                        set: { newValue in
                            viewModel.setHideSpoilers(newValue)
                        }
                    )
                )
                .font(.headline)
                .tint(.pink)

                Button {
                    onShowFunFact(film.title)
                } label: {
                    Text("Интересный факт")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
    }

    private func poster(_ film: OneFilmModel) -> some View {
        AsyncImage(url: URL(string: film.posterURL)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .fill(.gray.opacity(0.15))
                .overlay {
                    ProgressView()
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 420)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func filmInfo(_ film: OneFilmModel) -> some View {
        HStack(spacing: 12) {
            if let rating = film.kinopoiskRating {
                Label(
                    String(format: "%.1f", rating),
                    systemImage: "star.fill"
                )
            }

            if let year = film.year {
                Text(String(year))
            }

            if let length = film.filmLength {
                Text("\(length) мин")
            }

            if let ageLimit = film.ageLimit {
                Text(ageLimit.replacingOccurrences(of: "age", with: "") + "+")
            }
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(.secondary)
    }
}
