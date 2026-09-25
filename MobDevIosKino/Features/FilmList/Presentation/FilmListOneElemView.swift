import SwiftUI

struct FilmListOneElemView: View {
    let film: FilmListModel

    var body: some View {
        HStack(spacing: 16) {
            poster

            VStack(alignment: .leading, spacing: 4) {
                Text(film.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    if let year = film.year {
                        Text(String(year))
                    }
                    if let rating = film.rating {
                        Text("•")
                        Label(String(format: "%.1f", rating), systemImage: "star.fill")
                            .foregroundColor(.orange)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                if !film.genres.isEmpty {
                    Text(film.genres.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .frame(height: 122)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    @ViewBuilder
    private var poster: some View {
        AsyncImage(url: film.posterURL) { phase in
            switch phase {
            case .empty:
                Color.gray.opacity(0.2)

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            case .failure:
                Color.gray.opacity(0.2)
                    .overlay(
                        Image(systemName: "film")
                            .foregroundColor(.white)
                    )

            @unknown default:
                Color.gray.opacity(0.2)
            }
        }
        .frame(width: 60, height: 90)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
