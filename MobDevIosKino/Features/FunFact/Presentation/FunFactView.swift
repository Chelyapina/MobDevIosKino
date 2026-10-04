import SwiftUI

struct FunFactView: View {
    
    @StateObject private var viewModel: FunFactViewModel
    
    init(
        viewModel: @autoclosure @escaping () -> FunFactViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.purple.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
            
            content
        }
        
        .task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
            
        case .loaded(let fact):
            Text(fact.text)
                .font(.system(size: 18, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
        case .error(let message):
            VStack(spacing: 16) {
                Text(message)
                    .multilineTextAlignment(.center)
                
                Button("Повторить") {
                    Task {
                        await viewModel.retry()
                    }
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

