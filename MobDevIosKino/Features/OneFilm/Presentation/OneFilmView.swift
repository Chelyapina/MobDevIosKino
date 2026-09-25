import SwiftUI

struct OneFilmView: View {
    let filmId: Int

    var body: some View {
        ZStack {
            Color.blue.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "film")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)

                Text("Фильм")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("id: \(filmId)")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .monospacedDigit()
            }
            .padding(40)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OneFilmView(filmId: 263531)
    }
}
