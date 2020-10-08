import Combine

public class SyncCoordinator {
    
    private var initializeSubscription: AnyCancellable?
    
    public init() {}
    
    public func initialize() {
        initializeSubscription = Server.initialize()
            .sink { completion in
                
            } receiveValue: { server in
                
            }
    }
    
    public func startSync() {}
    
}
