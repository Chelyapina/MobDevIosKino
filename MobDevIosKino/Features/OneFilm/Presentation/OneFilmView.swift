import SwiftUI

struct OneFilmView: View {
    
    @StateObject private var viewModel: OneFilmViewModel
    
    let filmId: Int
    let onShowFunFact: () -> Void
    
    init(
           filmId: Int,
           viewModel: @autoclosure @escaping () -> OneFilmViewModel,
           onShowFunFact: @escaping () -> Void
       ) {
           self.filmId = filmId
           _viewModel = StateObject(wrappedValue: viewModel())
           self.onShowFunFact = onShowFunFact
       }

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
                
                HStack{
                    
                    Button {
                        onShowFunFact()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Text("Interesting fact")
                                .font(.custom("Montserrat-SemiBold", size: 16))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(Color(red: 0.72, green: 0.22, blue: 0.40))
                        .padding(.horizontal, 18)
                        .frame(height: 54)
                        .background(
                            Color(red: 1.0, green: 0.93, blue: 0.95)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
                .padding(40)
                //.background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            
            VStack {
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
                .padding()
                
                Spacer()
            }
        }.padding(7)
            
        .navigationTitle("Детали")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

/*#Preview {
    NavigationStack {
        OneFilmView(filmId: 263531, )
    }
 */
