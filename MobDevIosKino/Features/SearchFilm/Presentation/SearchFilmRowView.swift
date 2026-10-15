import SwiftUI

struct SearchFilmRowView: View {
    let film: SearchFilmModel

    var body: some View {
        HStack(spacing: 16) {
            poster

            VStack(alignment: .leading, spacing: 4) {
                Text(film.title)
                    .font(.headline)
                    .lineLimit(2)

                if let year = film.year {
                    Text(year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let description = film.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .frame(height: 122)
        .padding()
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
