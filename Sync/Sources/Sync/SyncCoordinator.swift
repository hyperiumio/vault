import Combine

public class SyncCoordinator {
    
    private var initializeSubscription: AnyCancellable?
    
    public init() {
        
    }
    
    public func initialize() {
        initializeSubscription = Server.initialize()
            .sink { completion in
                //print(completion)
            } receiveValue: { server in
                //print(server)
            }
    }
    
    public func startSync() {
        
    }
    
}
