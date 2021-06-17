import SwiftUI

struct AppCommands<S>: Commands where S: AppStateRepresentable {
    
    @ObservedObject var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some Commands {
        SidebarCommands()
        
        CommandGroup(before: .appTermination) {
            Button(.lockVault) {
                guard case .main(let state) = state.state else { return }
                
           //     state.lock()
            }
        }
    }
    
    
}
