import SwiftUI

struct AsyncView<Content, Failure, Loaded>: View where Content: View, Failure: View {
    
    @ObservedObject private var state: AsyncState<Loaded>
    private let content: (Loaded) -> Content
    private let failure: Failure
    
    public init(_ state: AsyncState<Loaded>, @ViewBuilder content: @escaping (Loaded) -> Content, @ViewBuilder failure: () -> Failure) {
        self.state = state
        self.content = content
        self.failure = failure()

    }
    
    var body: some View {
        Group {
            switch state.status {
            case .loading:
                ProgressView()
            case .failure:
                failure
            case let .loaded(state):
                content(state)
            }
        }
    }
    
}
