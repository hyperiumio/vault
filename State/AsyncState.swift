import Foundation

@MainActor
class AsyncState<Loaded>: ObservableObject {
    
    @Published private(set) var status = Status.loading
    private let load: () async throws -> Loaded
    
    init(load: @escaping () async throws -> Loaded) {
        self.load = load
        
        Task {
            do {
                let loadedState = try await load()
                status = .loaded(loadedState)
            } catch {
                status = .failure
            }
        }
    }
    
    func reload() {
        guard case .failure = status else { return }
        
        Task {
            do {
                let loadedState = try await load()
                status = .loaded(loadedState)
            } catch {
                status = .failure
            }
        }
    }
    
}

extension AsyncState {
    
    enum Status {
        
        case loading
        case failure
        case loaded(Loaded)
        
    }
    
}
